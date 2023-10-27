//
//  AlbumViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 08..
//

import Foundation
import CoreData
import SwiftUI
import Resolver

protocol AlbumViewModelInput: BaseViewModelInput {
}

@MainActor
final class AlbumViewModel: ObservableObject {
    // MARK: - Types

    // MARK: - Properties

    @Published private(set) var isLoading = false
    // MARK: - Initialization

    init() {
    }

    // MARK: - Functions

    func deleteAllItem(on context: NSManagedObjectContext) {
        isLoading = true
        CoreDataController().reset(context: context) { [weak self] in
            self?.isLoading = false
        }
    }
}

// MARK: - AlbumViewModelInput

extension AlbumViewModel: AlbumViewModelInput {
    func didAppear() {
    }

    func didDisAppear() {
    }
}
