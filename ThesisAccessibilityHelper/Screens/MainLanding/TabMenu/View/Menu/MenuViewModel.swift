//
//  MenuViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import Foundation

protocol MenuViewModelInput: BaseViewModelInput {
    func didTapItem()
}

@MainActor
final class MenuViewModel: ObservableObject {
    // MARK: - Properties

    @Published private(set) var indexes: [Int]

    private let tabHosterInstance = TabHosterViewViewModel.shared

    // MARK: - Initialization

    init() {
        _indexes = .init(wrappedValue: (1..<9).map { $0 })
    }
}

// MARK: - ObjectDetectViewModelInput

extension MenuViewModel: ObjectDetectViewModelInput {
    func didAppear() {
        tabHosterInstance.tabBarStatus.send(.hide)
    }

    func didDisAppear() {
        tabHosterInstance.tabBarStatus.send(.show)
    }

    func didTapItem() {
        tabHosterInstance.tabBarStatus.send(.hide)
    }
}
