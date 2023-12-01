//
//  ThesisAccessibilityHelperUITests.swift
//  ThesisAccessibilityHelperUITests
//
//  Created by Dudas Tamas Alex on 2023. 12. 02..
//

import XCTest
@testable import ThesisAccessibilityHelper

final class ThesisAccessibilityHelperUITests: XCTestCase {
    // MARK: - Types

    private struct Identifier {
        static let launchScreen = "TLaunchScreen"
    }

    private struct IdentifierError {
        static let launchScreen = "Launc screen not found"
    }

    // MARK: - XCTestCase functions

    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false
        let sut = XCUIApplication()
        sut.launch()
    }

    // MARK: - Functions

    func testLaunchScreen() throws {
        let sut = XCUIApplication()

        XCTAssertFalse(sut.otherElements[Identifier.launchScreen].exists, IdentifierError.launchScreen)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
