//
//  DemoLandingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import SwiftUI

struct DemoLandingView: View {
    // MARK: - Properties

    var body: some View {
        NavigationStack {
            BaseView {
                VStack(spacing: 15) {
                    Group {
                        NavigationLink {

                        } label: {
                            Text("Tracking Multiple Objects or Rectangles in Video")
                                .lineLimit(2)
                                .minimumScaleFactor(0.7)
                        }
                        NavigationLink {

                        } label: {
                            Text("Tracking the User’s Face in Real Time")
                                .lineLimit(2)
                                .minimumScaleFactor(0.7)
                        }
                        NavigationLink {

                        } label: {
                            Text("Counting human body action repetitions in a live video feed")
                                .lineLimit(2)
                                .minimumScaleFactor(0.7)
                        }
                        NavigationLink {

                        } label: {
                            Text("Selecting Photos and Videos in iOS - PhotoKit")
                                .lineLimit(2)
                                .minimumScaleFactor(0.7)
                        }

                        NavigationLink {

                        } label: {
                            Text("Explore a location with a highly detailed map and Look Around - Map Kit")
                                .lineLimit(2)
                                .minimumScaleFactor(0.7)
                        }

                        NavigationLink {
                            CustomCameraView()
                        } label: {
                            Text("Custom Camera")
                        }

                    }
                }
            }
            .navigationTitle("Apple Demos")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea()
        }
    }
}

// MARK: - Preview

struct DemoLandingView_Previews: PreviewProvider {
    static var previews: some View {
        DemoLandingView()
    }
}
