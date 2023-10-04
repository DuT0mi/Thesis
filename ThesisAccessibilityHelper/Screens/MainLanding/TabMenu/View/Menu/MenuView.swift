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
                            NavigationLink(destination: Circle5DetailView()) {
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

struct Circle5DetailView: View {
    var body: some View {
        Text("This is Circle 5's Detail View")
    }
}

struct Circle7DetailView: View {
    var body: some View {
        Text("This is Circle 7's Detail View")
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

#Preview {
    MenuView()
}
