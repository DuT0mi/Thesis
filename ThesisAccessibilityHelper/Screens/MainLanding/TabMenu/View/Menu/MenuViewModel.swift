//
//  MenuViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import Foundation

protocol MenuViewModelInput: BaseViewModelInput {
}

@MainActor
final class MenuViewModel: ObservableObject {
    // MARK: - Properties

    @Published private(set) var indexes: [Int]

    // MARK: - Initialization

    init() {
        _indexes = .init(wrappedValue: (1..<9).map { $0 })
    }
}
