//
//  SecureTextField.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import SwiftUI

/// A textfield with an oppurtunity to see the securefield's (`SecureField`) binded text.
struct SecureTextField: View {
    // MARK: - Properties

    @State private var isSecureField = true
    @Binding var secureText: String

    var body: some View {
        HStack {
            if isSecureField {
                SecureField("Password", text: $secureText)
            } else {
                TextField(secureText, text: $secureText)
            }
        }
        .overlay(alignment: .trailing) {
            Image(systemName: isSecureField ? "eye.slash" : "eye")
                .onTapGesture {
                    isSecureField.toggle()
                }
        }
    }
}

// MARK: - Preview

#Preview {
    SecureTextField(secureText: .constant("AA"))
}
