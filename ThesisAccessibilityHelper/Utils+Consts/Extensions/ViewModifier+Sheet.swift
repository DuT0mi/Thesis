//
//  ViewModifier+Sheet.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import SwiftUI

struct CustomSheetStyleModifier: ViewModifier {
    // MARK: - Types

    /// Could be also changing between programatically
    /// usage:  .presentationDetents(...., selection:)

    enum PresentationDententStyle {
        case medium
        case large
        case mixed // medium & large
        case fraction(_ fraction: CGFloat)
        case height(_ height: CGFloat)
    }

    // MARK: - Properties

    var presentationStyle: PresentationDententStyle = .medium
    var dismissable = true
    var showIndicator = true

    // MARK: - Fuctions

    func body(content: Content) -> some View {
        content
            .presentationDragIndicator(showIndicator ? .visible : .hidden)
            .interactiveDismissDisabled(!dismissable)
            .modifier(SheetDetentsModifier(presentationStyle: presentationStyle))
    }
}

// MARK: - SheetDetentsModifier

struct SheetDetentsModifier: ViewModifier {
    var presentationStyle: CustomSheetStyleModifier.PresentationDententStyle

    func body(content: Content) -> some View {
        switch presentationStyle {
        case .fraction(let fraction):
            return content.presentationDetents([.fraction(fraction)])
        case .height(let height):
            return content.presentationDetents([.height(height)])
        case .medium:
            return content.presentationDetents([.medium])
        case .large:
            return content.presentationDetents([.large])
        case .mixed:
            return content.presentationDetents([.large, .medium])
        }
    }
}

// MARK: - View extension

extension View {
    func sheetStyle(style: CustomSheetStyleModifier.PresentationDententStyle, dismissable: Bool, showIndicator: Bool) -> some View {
        self.modifier(
            CustomSheetStyleModifier(
                presentationStyle: style,
                dismissable: dismissable,
                showIndicator: showIndicator
            )
        )
    }
}
