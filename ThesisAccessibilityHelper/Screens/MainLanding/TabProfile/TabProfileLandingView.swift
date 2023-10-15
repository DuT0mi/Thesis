//
//  TabProfileLandingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import SwiftUI

struct TabProfileLandingView: View {
    // MARK: - Types

    private struct Consts {
        struct Layout {
            static let refreshTimeDefault: Int = -1
        }
    }

    // MARK: - Properties

    @StateObject private var viewModel = TabProfileLandingViewModel()
    @State private var interactiveMode = false
    @State private var refreshTime: Int = Consts.Layout.refreshTimeDefault
    @State private var showTimePicker = false

    private let columns = [
        MultiComponentPicker.Column(label: "s", options: Array(-1...60).map {
            MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) })
    ]

    var body: some View {
        BaseView {
            VStack {
                Form {
                    settingsSection
                }
                .formStyle(.grouped)
            }
        }
        .sheet(isPresented: $showTimePicker, onDismiss: {
            showTimePicker = false
        }, content: {
            MultiComponentPicker(columns: columns, selections: [
                Binding<Int>(get: { self.refreshTime }, set: { self.refreshTime = $0 }) ])
        })
        .task {
            await loadData()
        }
        .onDisappear {
            saveData()
        }
    }

    private var settingsSection: some View {
        Section {
            Toggle("Interactive mode", isOn: $interactiveMode)
                .onChange(of: interactiveMode) { _, newValue in
                    viewModel.setInteractiveMode(newValue)
                }
            Button {
                showTimePicker = true
            } label: {
                HStack {
                    Text("Object detect refresh time")
                        .foregroundStyle(.black)
                    Spacer()
                    VStack {
                        if refreshTime == Consts.Layout.refreshTimeDefault {
                            Text("Not set")
                                .foregroundStyle(.blue)
                        } else {
                            Text("\(refreshTime) s")
                                .foregroundStyle(.blue)
                            Text("Set -1 to default")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        } header: {
            Text("Settings")
        }
    }

    // MARK: - Functions

    private func loadData() async {
        interactiveMode = viewModel.interactiveMode
    }

    private func saveData() {
        viewModel.setRefreshTime(refreshTime)
    }
}

struct TabProfileLandingView_Previews: PreviewProvider {
    static var previews: some View {
        TabProfileLandingView()
    }
}
