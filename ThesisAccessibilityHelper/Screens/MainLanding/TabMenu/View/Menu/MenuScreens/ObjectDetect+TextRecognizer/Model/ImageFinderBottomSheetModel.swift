//
//  ImageFinderBottomSheetModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 13..
//

import Foundation
import CoreGraphics

/// A Model that represents the data layer for the scanning bottom sheet
/// - Parameters:
///   - frame: The frame of the image
///   - cameraModel: See  at``CameraManager``

struct ImageFinderBottomSheetModel {
    var frame: CGImage?
    var cameraModel: CameraManager.CameraResultModel
}
