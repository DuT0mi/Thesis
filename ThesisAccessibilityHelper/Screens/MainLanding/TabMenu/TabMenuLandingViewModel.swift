//
//  TabMenuLandingViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import Foundation
import Resolver

@MainActor
final class TabMenuLandingViewModel: ObservableObject {
    // MARK: - Properties

    @Published private(set) var isAuthenticated = false

    @LazyInjected private var authenticationInteractor: AuthenticationInteractor

    // MARK: - Functios

    func loadData() async {
        authenticationInteractor.encodeAuthenticatedStatus { [weak self] result in
            self?.isAuthenticated = result
        }
    }
}
