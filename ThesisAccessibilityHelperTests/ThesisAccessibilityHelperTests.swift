//
//  ThesisAccessibilityHelperTests.swift
//  ThesisAccessibilityHelperTests
//
//  Created by Dudas Tamas Alex on 2023. 12. 02..
//

import XCTest
@testable import ThesisAccessibilityHelper

final class ThesisAccessibilityHelperTests: XCTestCase {
    func test_levenshteinDistance_shouldbeTheSame_equals() {
        let sut = "tester"
        let input = "tester"

        let result = sut.levenshteinDistance(to: input)

        XCTAssertEqual(result, 0)
    }

    func test_levenshteinDistance_shouldbeTheSame_notEquals() {
        let sut = "tester"
        let input = "tester1"

        let result = sut.levenshteinDistance(to: input)
        
        XCTAssertNotEqual(result, 0)
    }

}
