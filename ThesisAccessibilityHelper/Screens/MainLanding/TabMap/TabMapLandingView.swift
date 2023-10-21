//
//  TabMapLandingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import SwiftUI

struct TabMapLandingView: View {
    // MARK: - Properties

    @StateObject private var viewModel = TabMapLandingViewModel()

    var body: some View {
        ZStack {
            MapView()
        }
        .onAppear {
            viewModel.didAppear()
        }
        .onDisappear {
            viewModel.didDisAppear()
        }
    }
}

struct TabMapLandingView_Previews: PreviewProvider {
    static var previews: some View {
        TabMapLandingView()
    }
}
