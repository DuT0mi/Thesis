//
//  CGImage+fromData.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 28..
//

import CoreGraphics
import VideoToolbox

extension CGImage {
    static func create(from imageData: Data?) -> CGImage? {
        var image: CGImage?
        if let data = imageData {
            if let dataProvider = CGDataProvider(data: data as CFData) {
                if let cgImage = CGImage(jpegDataProviderSource: dataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) {
                    image = cgImage
                }
            }
        }
        return image
    }
}
