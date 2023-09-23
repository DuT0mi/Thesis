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
                                MenuViewItem(systemName: "camera")
                            }

                            NavigationLink(destination: Circle2DetailView()) {
                                MenuViewItem()
                            }
                        }
                        .padding()

                        HStack(spacing: 20) {
                            NavigationLink(destination: Circle4DetailView()) {
                                MenuViewItem()
                            }
                            NavigationLink(destination: Circle5DetailView()) {
                                MenuViewItem()
                            }
                            NavigationLink(destination: Circle6DetailView()) {
                                MenuViewItem()
                            }
                        }
                        .padding()

                        HStack(spacing: 20) {
                            NavigationLink(destination: Circle7DetailView()) {
                                MenuViewItem()
                            }
                            NavigationLink(destination: Circle8DetailView()) {
                                MenuViewItem()
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
            }
            .ignoresSafeArea()
            .navigationTitle("Circle Menu")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Circle1DetailView: View {
    var body: some View {
        Text("This is Circle 1's Detail View")
    }
}

struct Circle2DetailView: View {
    var body: some View {
        Text("This is Circle 2's Detail View")
            .onAppear {
                SynthesizerManager.shared.speak(with: "Szia", completion: nil)
            }
    }
}

struct Circle3DetailView: View {
    var body: some View {
        Text("This is Circle 3's Detail View")
    }
}

struct Circle4DetailView: View {
    var body: some View {
        Text("This is Circle 4's Detail View")
    }
}

struct Circle5DetailView: View {
    var body: some View {
        Text("This is Circle 5's Detail View")
    }
}

struct Circle6DetailView: View {
    var body: some View {
        Text("This is Circle 6's Detail View")
    }
}

struct Circle7DetailView: View {
    var body: some View {
        Text("This is Circle 7's Detail View")
    }
}

struct Circle8DetailView: View {
    var body: some View {
        Text("This is Circle 8's Detail View")
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
