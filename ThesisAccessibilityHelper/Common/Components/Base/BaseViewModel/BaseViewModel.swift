//
//  BaseViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import Foundation
import Combine

protocol BaseViewModelInput: AnyObject {
    func didAppear()
    func didDisAppear()
}

class BaseViewModel: ObservableObject {

}

// MARK: - BaseViewModelInput

extension BaseViewModel: BaseViewModelInput {
    func didAppear() { }
    func didDisAppear() { }
}
