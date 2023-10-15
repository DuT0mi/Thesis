//
//  MenuView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import SwiftUI

struct MenuView: View {
    // MARK: - Properties

    @StateObject private var viewModel = MenuViewModel()

    var body: some View {
        NavigationView {
            BaseView {
                VStack {
                    Group {
                        HStack(spacing: 20) {
                            NavigationButton(delay: 1.0) {
                                viewModel.hideTabBar()
                                viewModel.didTapMenuItem(on: .objectDetect)
                            } destination: {
                                ObjectDetectView()
                            } label: {
                                MenuViewItem(image: .menuCamera)
                            }
                        }
                        .padding()

                        HStack(spacing: 20) {
                            NavigationButton {
                                viewModel.didTapMenuItem(on: .map)
                            } destination: {
                                TabMapLandingView()
                            } label: {
                                MenuViewItem(image: .menuMap)
                            }

                            NavigationButton {
                                viewModel.didTapMenuItem(on: .scan)
                            } destination: {
                                ScanDocumentView()
                            } label: {
                                MenuViewItem(image: .menuDocument)
                            }
                        }
                        .padding()

                        HStack(spacing: 20) {
                            NavigationButton {
                                viewModel.didTapMenuItem(on: .storage)
                            } destination: {
                                AlbumView()
                            } label: {
                                MenuViewItem(systemName: "externaldrive.badge.person.crop")
                            }
                        }
                        .padding()
                    }
                }
                .onAppear {
                    viewModel.didTapMenuItem(on: .`self`)
                }
                .navigationTitle("Circle Menu")
                .navigationBarTitleDisplayMode(.inline)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    MenuView()
}
