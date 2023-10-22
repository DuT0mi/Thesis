//
//  LandingViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 10..
//

import Foundation
import Combine
import Resolver

final class TabHosterViewViewModel: ObservableObject {
    // MARK: - Properties

    @Published var shouldShowTabBar = true

    static let shared = TabHosterViewViewModel()

    var tabBarStatus = PassthroughSubject<TabBarStatus, Never>()

    @LazyInjected private var pushnotificationInteractor: PushnotificationInteractor

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    private init() {
        subscribers()
    }

    // MARK: - Functions

    private func subscribers() {
        self.tabBarStatus
            .receive(on: RunLoop.main)
            .map { (status) -> Bool in
                status == .show
            }
            .sink { [weak self] receivedValue  in
                self?.shouldShowTabBar = receivedValue
            }
            .store(in: &cancellables)
    }
}

extension TabHosterViewViewModel: BaseViewModelInput {
    func didAppear() {
        pushnotificationInteractor.onAppearNotification()
    }

    func didDisAppear() {
    }
}
