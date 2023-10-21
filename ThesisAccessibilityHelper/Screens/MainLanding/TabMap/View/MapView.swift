//
//  MapView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 21..
//

import SwiftUI
import MapKit

struct MapView: View {
    // MARK: - Properties

    let bmeQ = CLLocationCoordinate2D(latitude: 47.473533988323574, longitude: 19.059854268015204)

    @State private var cameraPos: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $cameraPos) {
            Marker("BME Q", coordinate: bmeQ)
        }
    }
}

#Preview {
    MapView()
}
