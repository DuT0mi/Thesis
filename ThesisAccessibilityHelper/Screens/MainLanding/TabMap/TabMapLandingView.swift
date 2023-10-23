//
//  TabMapLandingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import SwiftUI
import MapKit

/// A View that shows the Map and Users on it based on the current user type
struct TabMapLandingView: View {
    // MARK: - Properties

    @StateObject private var viewModel = TabMapLandingViewModel()
    @State private var cameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @State private var lookAround: MKLookAroundScene?
    @State private var viewingRegion: MKCoordinateRegion?
    @State private var showSearchBar = false
    @State private var showDetails = false
    @State private var showRoute = false

    @Namespace var mapScope

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.extraLarge)
                    .foregroundStyle(.ultraThickMaterial)
                    .zIndex(viewModel.isLoading ? 1 : 0)
            }
            Map(position: $cameraPosition, interactionModes: .all, selection: $viewModel.mapSelection, scope: mapScope) {
                Marker("You", coordinate: viewModel.currentUserLocation ?? viewModel.defaultLocation)

                ForEach(viewModel.searchResults, id: \.self) { mapItem in
                    if showRoute {
                        if mapItem == viewModel.routeDestinitation {
                            let placeMark = mapItem.placemark
                            Marker(placeMark.name ?? "Place", coordinate: placeMark.coordinate)
                                .tint(Color.blue)
                        }
                    } else {
                        let placeMark = mapItem.placemark
                        Marker(placeMark.name ?? "Place", coordinate: placeMark.coordinate)
                            .tint(Color.blue)
                    }
                }

                if viewModel.helpers.count != .zero {
                    ForEach(viewModel.helpers, id: \.self) { helperMapItem in
                        let placeMark = helperMapItem.placemark
                        Marker(viewModel.titleForMarker, coordinate: placeMark.coordinate)
                    }
                }

                if let route = viewModel.route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, style: .init(lineWidth: 10))
                }
            }
            .onMapCameraChange({ mapCameraUpdateContext in
                viewingRegion = mapCameraUpdateContext.region
                Task {
                    await viewModel.performanceSearch(with: viewingRegion)
                }
            })
            .mapControls {
                MapCompass(scope: mapScope)
                MapUserLocationButton(scope: mapScope)
                MapPitchToggle(scope: mapScope)
                MapScaleView(scope: mapScope)
            }
            .zIndex(viewModel.isLoading ? .zero : 1)
            .searchable(text: $viewModel.searchText, isPresented: $showSearchBar)
            .allowsHitTesting(viewModel.isLoading ? false : true)
        }
        .task {
            await viewModel.loadData() // TODO: Create MOCK Scheme (+more) <- preview going to crash anytime
        }
        .ignoresSafeArea(.all, edges: [.horizontal, .bottom])
        .onAppear {
            viewModel.didAppear()
        }
        .onDisappear {
            viewModel.didDisAppear()
        }
        .navigationTitle("Finder")
        .toolbar(showRoute ? .hidden : .visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .onSubmit(of: .search) {
            Task {
                await viewModel.performanceSearch()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "mappin.slash.circle.fill")
                    .foregroundStyle(viewModel.searchResults.count == .zero ? .gray : .red)
                    .frame(width: 28, height: 28)
                    .onTapGesture {
                        viewModel.resetResult()
                    }
                    .allowsHitTesting(viewModel.searchResults.count == .zero ? false : true)
            }
        }
        .onChange(of: viewModel.mapSelection) { oldValue, newValue in
            showDetails = newValue != nil

            fetchLookAround()
        }
        .onChange(of: showSearchBar, initial: false) {
            guard !showSearchBar else { return }

            showDetails = false

            // swiftlint: disable line_length
            withAnimation(.snappy) {
                cameraPosition = .region(viewingRegion ?? .init(center: viewModel.currentUserLocation ?? CLLocationCoordinate2D.bmeQLoc, latitudinalMeters: 100, longitudinalMeters: 100))
            }
            // swiftlint: enable line_length
        }
        .sheet(isPresented: $showDetails, onDismiss: {
            withAnimation(.smooth) {
                if let boundingRect = viewModel.route?.polyline.boundingMapRect, showRoute {
                    cameraPosition = .rect(boundingRect)
                }
            }
        }, content: {
            buildMapDetails()
                .sheetStyle(style: .mixed, dismissable: true, showIndicator: true)
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .presentationCornerRadius(30)
        })
        .safeAreaInset(edge: .bottom) {
            if showRoute {
                Button("End route") {
                    withAnimation(.snappy) {
                        showRoute = false
                        showDetails = true
                        viewModel.mapSelection = viewModel.routeDestinitation
                        viewModel.routeDestinitation = nil
                        viewModel.route = nil
                        if let mapSelection = viewModel.mapSelection {
                            cameraPosition = .item(mapSelection)
                        }
                    }
                }
                .foregroundStyle(.white)
                .bold()
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(.red.gradient, in: .rect(cornerRadius: 15))
                .padding()
                .background(.ultraThinMaterial)
            }
        }
    }

    // MARK: - Functions

    // swiftlint: disable function_body_length
    @ViewBuilder
    func buildMapDetails() -> some View {
        VStack(spacing: 16) {
            ZStack {
                if let lookAround {
                    LookAroundPreview(scene: $lookAround)
                } else {
                    ContentUnavailableView("No preview available", systemImage: "eye.slash")
                }
            }
            .frame(minHeight: 200, maxHeight: 250)
            .clipShape(.rect(cornerRadius: 15))
            .overlay(alignment: .topTrailing) {
                Button {
                    showDetails = false
                    withAnimation(.snappy) {
                        viewModel.mapSelection = nil
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.black)
                        .background(.white, in: .circle)
                }
                .padding(8)
            }
            .overlay(alignment: .topLeading) {
                Button {
                    viewModel.routeDestinitation = viewModel.mapSelection
                    let options = [
                        MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,
                        MKLaunchOptionsMapCenterKey: viewModel.routeDestinitation?.placemark.coordinate
                    ] as [String: Any]
                    viewModel.routeDestinitation?.openInMaps(launchOptions: options)
                } label: {
                    Image(systemName: "arrow.up.forward.app.fill")
                        .font(.title)
                        .foregroundStyle(.black)
                        .background(.white, in: .circle)
                }
                .padding(8)
            }

            Button("Get direction") {
                viewModel.fetchRoutes()
                viewModel.routeDestinitation = viewModel.mapSelection // Required because of when tap on the mapSelection it will be nil by default
                withAnimation(.snappy) {
                    showRoute = true
                    showDetails = true
                }
            }
            .foregroundStyle(.white)
            .bold()
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(.blue.gradient, in: .rect(cornerRadius: 15))
        }
        .padding()
    }
    // swiftlint: enable function_body_length

    @MainActor
    func fetchLookAround() {
        guard let mapSelection = viewModel.mapSelection else { return }

        lookAround = nil
        Task {
            let request = MKLookAroundSceneRequest(mapItem: mapSelection)
            lookAround = try? await request.scene
        }
    }
}

struct TabMapLandingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TabMapLandingView()
                .ignoresSafeArea()
        }
    }
}
