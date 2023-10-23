//
//  ImageCoordinatePointView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 14..
//

import SwiftUI

/// A View that is represents a Coordinate point used, at ``ImageFinderBottomSheetView``
struct ImageCoordinatePointView: View {
    // MARK: - Types

    private struct Consts {
        struct Layout {
            static let frame: CGFloat = 40
        }
    }

    // MARK: - Properties

    var text: String?

    var body: some View {
        ZStack {
            Circle()
                .frame(width: Consts.Layout.frame, height: Consts.Layout.frame)
                .clipShape(.circle)
                .foregroundStyle(.blue).opacity(0.8)
                .overlay {
                    Text(text ?? "")
                        .font(.system(size: 6))
                        .foregroundStyle(.white)
                        .frame(width: Consts.Layout.frame, height: Consts.Layout.frame)
                        .bold()
                }

        }
    }
}

// MARK: - Preview

#Preview {
    ImageCoordinatePointView()
}
