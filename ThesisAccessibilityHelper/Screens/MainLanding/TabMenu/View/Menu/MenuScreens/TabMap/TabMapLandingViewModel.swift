//
//  TabMapLandingViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 21..
//

import Foundation
import Resolver
import MapKit
import Combine
import SwiftUI

/// A View Model for the ``TabMapLandingView``
final class TabMapLandingViewModel: NSObject, ObservableObject {
    // MARK: - Types

    private struct Consts {
        static let bmeQLa: CLLocationDegrees = 47.473533988323574
        static let bmeQLo: CLLocationDegrees = 19.059854268015204
        static let pollRequestTime: TimeInterval = 15
    }

    /// A Model that is represent a marker and the corresponding userID for the marker
    /// - Parameters:
    ///  - mkMap: The MKMapItem
    ///  - userID: The corresponding userID of the location
    ///  - id: For conforming to Identifiable
    struct MarkerItem: Identifiable {
        var mkMap: MKMapItem
        var userID: String

        var id: UUID {
            UUID()
        }
    }

    // MARK: - Properties

    @Published var searchText = ""
    @Published var mapSelection: MKMapItem?
    @Published var routeDestinitation: MKMapItem?
    @Published var route: MKRoute?

    @Published private(set) var currentUserLocation: CLLocationCoordinate2D?
    @Published private(set) var isLoading = true
    @Published private(set) var searchResults = [MKMapItem]()
    @Published private(set) var usersBasedOnType = [MKMapItem]()
    @Published private(set) var mapNotification = [MapNotification]()

    @Published private(set) var titleForMarker = "..."

    private var cachedUser: UserModelInput?
    private lazy var cachedHelperModel = [MarkerItem]()

    private var isNotificationBeignHandled = false

    //    var lookAroundBindingWrapper: Binding<MKLookAroundScene?> {
    //        Binding {
    //            self.lookAround
    //        } set: { newValue in
    //            self.lookAround = newValue
    //        }
    //    }

    private(set) var defaultLocation: CLLocationCoordinate2D = .init(latitude: Consts.bmeQLa, longitude: Consts.bmeQLo)

    @LazyInjected private var tabHosterInstance: TabHosterViewViewModel
    @LazyInjected private var firestoreDBInteractor: FireStoreDatabaseInteractor
    @LazyInjected private var authenticationInteractor: AuthenticationInteractor
    @LazyInjected private var speaker: SynthesizerManager

    private lazy var locationManager = CLLocationManager()

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    override init() {
        super.init()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

        Task {
            await self.addSubscribers()
            await self.setup()
        }
    }

    //    deinit {
    //        Task {
    //            await firestoreDBInteractor.removeListener()
    //        }
    //    }

    // MARK: - Functions

    @MainActor
    private func setup() {
        switch locationManager.authorizationStatus {
            case .authorizedWhenInUse:
                locationManager.requestLocation()
            case .notDetermined:
                locationManager.startUpdatingLocation()
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways:
                locationManager.requestAlwaysAuthorization()
            default:
                break
        }
    }

    @MainActor
    private func addSubscribers() {
        $searchText
            .removeDuplicates()
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                Task {
                    await self?.performanceSearch()
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    func performanceSearch(with region: MKCoordinateRegion? = nil) async {
        guard !searchText.isEmpty else { return }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region ?? .bmeQRegion

        let result = try? await MKLocalSearch(request: request).start()

        searchResults = result?.mapItems ?? []
    }

    @MainActor
    func resetResult() {
        guard !searchResults.isEmpty else { return }
        self.searchResults.removeAll()
    }

    @MainActor
    func fetchRoutes() {
        if let mapSelection, let currentUserLocation {
            let request = MKDirections.Request()
            request.source = .init(placemark: .init(coordinate: currentUserLocation))
            request.destination = mapSelection
            // TODO: More params..

            Task {
                let eta = try? await MKDirections(request: request).calculateETA()
                let result = try? await MKDirections(request: request).calculate()
                if let eta {
                    await self.sendNotification(eta: eta, mapselection: mapSelection)
                }
                self.route = result?.routes.first
            }
        }
    }

    @MainActor
    func loadData() async {
        await fetchUsers()
    }

    func didCloseNotification() {
        isNotificationBeignHandled = false

        if let noti = mapNotification.first {
            Task {
                try? await firestoreDBInteractor.updateNotificationStatus(for: noti.notificationID)
            }
        }
        speaker.playSystemSound(.confirm)
        speaker.speak(with: "Sikersen bezártad az értesítést!")
        mapNotification.removeAll()
    }

    // swiftlint:disable line_length
    func didTapToSpeak(on notification: MapNotification) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = .current
        dateFormatter.calendar = .current

        let arrivalDate = dateFormatter.date(from: notification.etaExpectedArrivalDate?.description ?? "")
        let nowDate = dateFormatter.date(from: Date().description)

        speaker.speak(with: "Az értesítés \(String(describing: notification.senderID))-től érkezett, várható érkezés \(notification.etaExpectedTravelTime ?? .nan) másodperc, a segítő: \(String(describing: notification.etaDistance)) méter távolságra van tőled, nagyjából \(arrivalDate ?? .distantFuture)-ra fog megérkezni és most \(nowDate ?? .now) az idő")
    }
    // swiftlint:enable line_length

    @MainActor
    private func sendNotification(eta: MKDirections.ETAResponse, mapselection: MKMapItem) async {
        if !cachedHelperModel.isEmpty, let cachedUser {
            guard let receiver = cachedHelperModel.first(where: { $0.mkMap.isEqual(mapselection) }), cachedUser.type == .helper else { return }

            let notification = MapNotification(
                notificationID: UUID().uuidString,
                date: Date(),
                senderID: cachedUser.userID,
                receiverID: receiver.userID,
                didSent: false,
                etaExpectedTravelTime: eta.expectedTravelTime,
                etaDistance: eta.distance,
                etaExpectedArrivalDate: eta.expectedArrivalDate
            )

            await firestoreDBInteractor.createNotification(notification)
        }
    }

    // swiftlint: disable identifier_name
    /// A function that fetch the users, the name may be not properly
    /// - Returns:
    ///  - If the current user type **helper**, then the `usersBasedOnType` will be *impared*
    ///  - If the current user type **impared**, then the `usersBasedOnType` will be *helpers*
    @MainActor
    private func fetchUsers() async {
        if let userID = authenticationInteractor.getCurrentUser()?.uid, let _currentUser = try? await firestoreDBInteractor.getUserBased(on: userID) {
            var users: [UserModelInput]?
            cachedUser = _currentUser
            switch _currentUser.type {
                case .helper:
                    setTitle("Impared")
                    users = try? await firestoreDBInteractor.fetchImpared()
                case .impared:
                    setTitle("Helper")
                    users = try? await firestoreDBInteractor.fetchHelpers()
            }
            userMapper(users: users)
        }
    }
    // swiftlint: enable identifier_name

    private func userMapper(users: [UserModelInput]?) {
        guard let users else { return }

        usersBasedOnType = users
            .lazy
            .filter { $0.latitude != nil && $0.longitude != nil }
            .map {
                let item = MKMapItem(placemark: .init(coordinate: .init(latitude: $0.latitude!, longitude: $0.longitude!)))
                cachedHelperModel.append(.init(mkMap: item, userID: $0.userID))
                return item
            }
    }

    private func setTitle(_ title: String) {
        guard !title.isEmpty else { return }

        titleForMarker = title
    }

    // swiftlint: disable identifier_name
    private func pollNotification() {
        Task {
            guard let polledValue = await firestoreDBInteractor.getNotification() else {
                print("Not received polled value at: \(#file), function: \(#function)")

                return
            }
            if let cachedUser {
                handleNotifications(polledValue, currentUser: cachedUser)
            } else if let userID = await authenticationInteractor.getCurrentUser()?.uid, let _currentUser = try? await firestoreDBInteractor.getUserBased(on: userID) {
                handleNotifications(polledValue, currentUser: _currentUser)
            }
        }
    }
    // swiftlint: enable identifier_name
    private func handleNotifications(_ notification: MapNotification, currentUser: UserModelInput) {
        guard let receiverID = notification.receiverID, receiverID == currentUser.userID else { return }

        isNotificationBeignHandled = true

        DispatchQueue.main.async { [weak self] in
            self?.mapNotification.append(notification)
            self?.speaker.playSystemSound(1003)
            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 1) {
                self?.speaker.speak(with: "Értesítésed jött, nyomd meg kétszer rövid időn belül képernyő közepén lévő nézetet a felolvasásért, vagy 2 másodpercig a becsukásért")
            }
        }
    }
}

// MARK: - BaseViewModelInput

extension TabMapLandingViewModel: BaseViewModelInput {
    func didAppear() {
        tabHosterInstance.tabBarStatus.send(.hide)

        Timer.publish(every: Consts.pollRequestTime, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                if self?.isNotificationBeignHandled == false {
                    self?.pollNotification()
                }
            }
            .store(in: &cancellables)
    }

    func didDisAppear() {
        tabHosterInstance.tabBarStatus.send(.show)
    }
}

// MARK: - CLLocationManagerDelegate

extension TabMapLandingViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error)")
        // TODO: Present alert
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.currentUserLocation = locations.first?.coordinate
            self.isLoading = false
        }
    }
}

// MARK: - CLLocationCoordinate2D

extension CLLocationCoordinate2D {
    private struct Consts {
        static let bmeQLa: CLLocationDegrees = 47.473533988323574
        static let bmeQLo: CLLocationDegrees = 19.059854268015204
    }

    static var bmeQLoc: CLLocationCoordinate2D {
        .init(latitude: Consts.bmeQLa, longitude: Consts.bmeQLo)
    }
}

// MARK: - MKCoordinateRegion

extension MKCoordinateRegion {
    static var bmeQRegion: MKCoordinateRegion {
        .init(center: .bmeQLoc, latitudinalMeters: 100, longitudinalMeters: 100)
    }
}
