//
//  MapNotificationView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 28..
//

import SwiftUI

struct MapNotificationView: View {
    // MARK: - Types

    private struct Consts {
        struct Layout {
            static let cornerRadius: CGFloat = 16
        }
    }

    var mapNotification: MapNotification
    var action: (() -> Void)?
    var longAction: (() -> Void)?

    @State var angle = Angle(degrees: .zero)

    // MARK: - Properties

    var body: some View {
        Button {
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: Consts.Layout.cornerRadius, style: .circular)
                    .stroke(lineWidth: 10)
                    .foregroundStyle(Color.black)
                    .frame(width: AppConstants.ScreenDimensions.width * 0.9, height: AppConstants.ScreenDimensions.height * 0.6)
                    .zIndex(1)
                RoundedRectangle(cornerRadius: Consts.Layout.cornerRadius, style: .circular)
                    .foregroundStyle(Color.green.gradient.opacity(0.8))
                    .frame(width: AppConstants.ScreenDimensions.width * 0.9, height: AppConstants.ScreenDimensions.height  * 0.6)
                    .overlay {
                        ScrollView(.vertical) {
                            LazyVStack(spacing: 20) {
                                Text("You have got a notification! 🎉🍾🎈")
                                    .font(.title)
                                    .bold()
                                    .frame(maxWidth: AppConstants.ScreenDimensions.width * 0.9)
                                    .foregroundStyle(.black)
                                Text(verbatim: "From: \(mapNotification.senderID ?? "")")
                                    .font(.title2)
                                    .bold()
                                    .frame(maxWidth: AppConstants.ScreenDimensions.width * 0.9)
                                    .foregroundStyle(.black)
                                Text(verbatim: "Expected travel time of the helper: \(mapNotification.etaExpectedTravelTime ?? .nan)seconds")
                                    .font(.title2)
                                    .bold()
                                    .frame(maxWidth: AppConstants.ScreenDimensions.width * 0.9)
                                    .foregroundStyle(.black)
                                Text(verbatim: "Distance from the helper: \(mapNotification.etaDistance ?? .nan)meters")
                                    .font(.title2)
                                    .bold()
                                    .frame(maxWidth: AppConstants.ScreenDimensions.width * 0.9)
                                    .foregroundStyle(.black)
                                HStack {
                                    Text(verbatim: "Expected Date: \(mapNotification.etaExpectedArrivalDate ?? .distantFuture)")
                                        .font(.title2)
                                        .bold()
                                        .frame(maxWidth: AppConstants.ScreenDimensions.width * 0.9)
                                        .foregroundStyle(.black)
                                    Text(verbatim: "Current Date: \(Date() ?? .now)")
                                        .font(.title2)
                                        .bold()
                                        .frame(maxWidth: AppConstants.ScreenDimensions.width * 0.9)
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                        .padding()
                    }
            }
            .rotationEffect(angle)
            .onAppear {
                withAnimation(.spring(duration: 1.5)) {
                    angle = .degrees(360)
                }
            }
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 2, maximumDistance: 20)
                .onEnded { _ in
                    longAction?()
                }
        )
        .highPriorityGesture(
            TapGesture(count: 2)
                .onEnded { _ in
                    action?()
                }
        )
    }
}

#Preview {
    MapNotificationView(mapNotification: .init(
        notificationID: "aa",
        date: Date(),
        senderID: "senderID",
        receiverID: "ReceivedID",
        didSent: false,
        etaExpectedTravelTime: 470,
        etaDistance: 540,
        etaExpectedArrivalDate: Date()))
}
