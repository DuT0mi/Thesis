//
//  CameraFrameView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import SwiftUI

/// The actual capture whole camera view
/// - Parameters:
///  - image: The current image (CVPixelBuffer -> CGImage)
///  - imageOrientation: The orientation of the image, the default is: *.upMirrored*
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
            ZStack {
                Image(image, scale: Consts.Layout.imageScale, orientation: imageOrientation, label: accessabilityLabel)
                    .resizable()
                    .scaledToFill()
                    .frame(width: AppConstants.AppDimension.width, height: AppConstants.AppDimension.height, alignment: .center)
                    .clipped()
            }
        } else {
            Color.black
        }
    }

    private let accessabilityLabel = Text("Camera feed for real-time object detection")
}
