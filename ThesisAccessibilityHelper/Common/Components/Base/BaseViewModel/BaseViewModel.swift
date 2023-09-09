//
//  BaseViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import Foundation

protocol BaseViewModelInput: AnyObject {
    var title: String? { get }
}

class BaseViewModel: ObservableObject {

}

// MARK: - BaseViewModelInput

extension BaseViewModel: BaseViewModelInput {
    var title: String? {
        nil
    }
}
