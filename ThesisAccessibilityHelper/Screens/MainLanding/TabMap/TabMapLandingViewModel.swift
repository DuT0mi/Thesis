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

final class TabMapLandingViewModel: NSObject, ObservableObject {
    // MARK: - Types

    private struct Consts {
        static let bmeQLa: CLLocationDegrees = 47.473533988323574
        static let bmeQLo: CLLocationDegrees = 19.059854268015204
    }

    // MARK: - Properties

    @Published var searchText = ""
    @Published var mapSelection: MKMapItem?
    @Published var routeDestinitation: MKMapItem?
    @Published var route: MKRoute?

    @Published private(set) var currentUserLocation: CLLocationCoordinate2D?
    @Published private(set) var isLoading = true
    @Published private(set) var searchResults = [MKMapItem]()
    @Published private(set) var helpers = [MKMapItem]()

    @Published private(set) var titleForMarker = "..."

    private var _currentUser: UserModelInput?

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
//                let result = try? await MKDirections(request: request).calculateETA() // TODO: ETA and more
                let result = try? await MKDirections(request: request).calculate()
                self.route = result?.routes.first
            }
        }
    }

    @MainActor
    func loadData() async {
        await fetchUsers()
    }

    // swiftlint: disable identifier_name
    @MainActor
    private func fetchUsers() async {
        if let userID = authenticationInteractor.getCurrentUser()?.uid, let _currentUser = try? await firestoreDBInteractor.getUserBased(on: userID) {
            var users: [UserModelInput]?
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

        helpers = users
            .lazy
            .filter { $0.latitude != nil && $0.longitude != nil }
            .map {
                MKMapItem(placemark: .init(coordinate: .init(latitude: $0.latitude!, longitude: $0.longitude!)))
            }
    }

    private func setTitle(_ title: String) {
        guard !title.isEmpty else { return }

        titleForMarker = title
    }
}

// MARK: - BaseViewModelInput

extension TabMapLandingViewModel: BaseViewModelInput {
    func didAppear() {
        tabHosterInstance.tabBarStatus.send(.hide)
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
