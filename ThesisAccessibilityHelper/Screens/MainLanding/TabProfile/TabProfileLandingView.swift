//
//  TabProfileLandingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import SwiftUI

struct TabProfileLandingView: View {
    // MARK: - Properties

    @StateObject private var viewModel = TabProfileLandingViewModel()
    @State private var interactiveMode = false

    var body: some View {
        BaseView {
            VStack {
                Form {
                    settingsSection
                }
                .formStyle(.grouped)
            }
        }
        .task {
            interactiveMode = viewModel.interactiveMode
        }
    }

    private var settingsSection: some View {
        Section {
            Toggle("Interactive mode", isOn: $interactiveMode)
                .onChange(of: interactiveMode) { _, newValue in
                    viewModel.setInteractiveMode(newValue)
                }
        } header: {
            Text("Settings")
        }

    }
}

struct TabProfileLandingView_Previews: PreviewProvider {
    static var previews: some View {
        TabProfileLandingView()
    }
}
