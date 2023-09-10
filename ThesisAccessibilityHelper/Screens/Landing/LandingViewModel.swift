//
//  LandingViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 10..
//

import Foundation
import Combine

final class LandingViewModel: ObservableObject {
    // MARK: - Properties

    @Published var shouldShowTabBar = true

    var tabBarStatus = PassthroughSubject<TabBarStatus, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init() {
        subscribers()
    }

    // MARK: - Functions

    private func subscribers() {
        self.tabBarStatus
            .map { (status) -> Bool in
                status == .show ? true : false
            }
            .sink { [weak self] receivedValue  in
                self?.shouldShowTabBar = receivedValue
            }
            .store(in: &cancellables)

    }
}
