//
//  PopupView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import SwiftUI

struct PopUpView: View{
    // MARK: - Properties

    var body: some View {
        VStack{
            Image(systemName: "person.crop.circle.badge.checkmark")
                .foregroundColor(Color(red: 0, green: 0.4, blue: 0))
                .bold()
                .padding()
            Spacer()
        }
    }
}

#Preview {
    PopUpView()
}
