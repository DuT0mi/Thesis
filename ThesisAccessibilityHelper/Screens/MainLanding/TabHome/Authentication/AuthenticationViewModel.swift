//
//  AuthenticationViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import Foundation

final class AuthenticationViewModel: ObservableObject {
    // MARK: - Properties

    @Published var email = String()
    @Published var password = String()

    // MARK: - Functions

    func didTapButton(with type: AuthenticationView.Page) {
        debugPrint(type)
    }
}

extension AuthenticationViewModel: BaseViewModelInput {
    func didAppear() {
    }

    func didDisAppear() {
    }
}
