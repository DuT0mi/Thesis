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
                                viewModel.didTapItem()
                            } destination: {
                                ObjectDetectView()
                            } label: {
                                MenuViewItem(image: .menuCamera)
                            }
                        }
                        .padding()

                        HStack(spacing: 20) {
                            NavigationLink(destination: TabMapLandingView()) {
                                MenuViewItem(image: .menuMap)
                            }

                            NavigationLink(destination: ScanDocumentView()) {
                                MenuViewItem(image: .menuDocument)
                            }
                        }
                        .padding()

                        HStack(spacing: 20) {
                            NavigationLink(destination: AlbumView()) {
                                MenuViewItem(systemName: "externaldrive.badge.person.crop")
                            }
                        }
                        .padding()
                    }
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
