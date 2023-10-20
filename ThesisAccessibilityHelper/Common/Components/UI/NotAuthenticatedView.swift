//
//  NotAuthenticatedView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import SwiftUI

struct NotAuthenticatedView: View {
    // MARK: - Types

    private struct Consts {
        struct Layout {
            static let imageSize: CGFloat = 200
        }

        struct Image {
            static let lock = "lock.trianglebadge.exclamationmark"
        }

        struct Appearance {
            static let bgOpacity: CGFloat = 0.5
            static let imgOpacity: CGFloat = 1
        }
    }
    // MARK: - Properties

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(Consts.Appearance.bgOpacity))
                        .frame(width: Consts.Layout.imageSize * 1.2, height: Consts.Layout.imageSize * 1.2)
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 10)
                        .frame(width: Consts.Layout.imageSize * 1.2, height: Consts.Layout.imageSize * 1.2)
                        .overlay {
                            Image(systemName: Consts.Image.lock)
                                .resizable()
                                .frame(width: Consts.Layout.imageSize, height: Consts.Layout.imageSize)
                                .foregroundStyle(.red.opacity(Consts.Appearance.imgOpacity))
                        }
                }
                Spacer()
                Text("Go to Home and sign in or login to your account")
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .font(.title)
                    .bold()
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    NotAuthenticatedView()
}
