//
//  ImageFinderBottomSheetView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 13..
//

import SwiftUI
import Resolver

struct ImageFinderBottomSheetView: View {
    // MARK: - Properties

    @ObservedObject private var scanViewModel: ScanDocumentViewModel = Resolver.resolve()
    @Environment(\.dismiss) private var dismiss
    @State private var currentImageSize: CGSize = .zero
    @State private var scaleFactor: CGSize = .zero
    @State private var shouldScale = false

    var image: Image?
    var model: ImageFinderBottomSheetModel

    var body: some View {
        BaseView {
            VStackLayout {
                HStack {
                    Spacer()
                    toolBarItem
                }
                ScrollView {
                    LazyVStack {
                        if let image {
                            image
                                .resizable()
                                .frame(width: currentImageSize.width * 0.4, height: currentImageSize.height * 0.4)
                                .clipShape(.rect(cornerRadius: currentImageSize.height * 0.3 * 0.1))
                                .scaleEffect(x: shouldScale ? 0.8 : 0.4, y: shouldScale ? 0.8 : 0.4)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 1.0)) {
                                        shouldScale.toggle()
                                    }
                                }
                        } else {
                            ProgressView() // TODO: Custom Error
                        }
                    }
                }
            }
        }
        .onAppear {
            guard let frame = model.frame else { return }
            currentImageSize = .init(width: frame.width, height: frame.height)
        }
        .ignoresSafeArea()
    }

    private var toolBarItem: some View {
        Image(systemName: "xmark.square.fill")
            .resizable()
            .frame(width: 28, height: 28)
            .foregroundStyle(.red)
            .shadow(color: .secondary.opacity(0.5), radius: 5, x: .zero, y: .zero)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }

    // MARK: - Functions
}

#Preview {
    ImageFinderBottomSheetView(image: Image(systemName: "house"), model: .init(cameraModel: CameraManager.defaultCameraResultModel))
}
