//
//  CameraFrameView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import SwiftUI

struct CameraFrameView: View {
    // MARK: - Types

    private struct Consts {
        struct Layout {
            static let imageScale: CGFloat = 1.0
        }
    }

    // MARK: - Properties

    var image: CGImage?
    var imageOrientation: Image.Orientation = .upMirrored

    var body: some View {
        if let image {
            GeometryReader { geometryProxy in
                Image(image, scale: Consts.Layout.imageScale, orientation: imageOrientation, label: accessabilityLabel)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometryProxy.size.width, height: geometryProxy.size.height, alignment: .center)
                    .clipped()
            }
        } else {
            Color.black
        }
    }

    private let accessabilityLabel = Text("Camera feed for real-time object detection")
}
