//
//  HomeInfoView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import SwiftUI

/// The info view about the app
struct HomeInfoView: View {
    // MARK: - Properties

    // swiftlint:disable line_length
    private let infoString = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ut tellus sed sapien feugiat iaculis. Aenean nec dolor sodales, dapibus lectus vel, iaculis erat. Sed tincidunt arcu ipsum, sit amet volutpat quam finibus vitae. Duis pellentesque, est pretium mattis vulputate, dolor massa gravida nibh, vel posuere ipsum felis quis sem. Vestibulum vulputate eleifend magna sed mattis. Ut auctor, nibh sed vestibulum dapibus, justo neque tristique justo, vitae facilisis libero ligula vitae nunc. Praesent mi orci, consectetur id ultricies laoreet, volutpat ut eros. Vestibulum vulputate metus pulvinar, finibus nunc ut, eleifend neque.

Mauris ac purus massa. Fusce tristique fermentum sem, in vestibulum augue laoreet eu. Donec convallis augue et feugiat vulputate. Aenean enim lacus, blandit vel tortor ac, congue lobortis urna. Maecenas cursus mauris ac tincidunt pharetra. Duis fringilla purus ut venenatis tempus. Proin orci sapien, mollis sit amet maximus id, maximus vel felis. Cras pharetra odio ut lacus aliquam, at tristique diam auctor. Proin quis lorem velit. Aliquam erat volutpat. Proin pretium ex fermentum porta sollicitudin. Integer sed velit quis tellus posuere tempus vel a est. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
"""
    var body: some View {
        BaseView {
            ScrollView {
                Text(infoString)
                    .padding()
            }
            .ignoresSafeArea()
        }
    }
    // swiftlint:enable line_length
}

// MARK: - Preview

#Preview {
    HomeInfoView()
}
