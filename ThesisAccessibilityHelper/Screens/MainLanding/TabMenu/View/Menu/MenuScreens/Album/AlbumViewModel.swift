//
//  AlbumViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 08..
//

import Foundation
import CoreData
import SwiftUI

protocol AlbumViewModelInput: BaseViewModelInput {
}

@MainActor
final class AlbumViewModel: ObservableObject {
    // MARK: - Types

    // MARK: - Properties

    // MARK: - Initialization

    init() {
    }

    // MARK: - Functions
}

// MARK: - AlbumViewModelInput

extension AlbumViewModel: AlbumViewModelInput {
    func didAppear() {
    }

    func didDisAppear() {
    }
}
