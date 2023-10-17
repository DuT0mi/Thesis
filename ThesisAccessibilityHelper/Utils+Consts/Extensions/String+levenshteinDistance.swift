//
//  String+levenshteinDistance.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 17..
//

import Foundation

/// Levenshtein Distance, which calculates the number of insertions, deletions, or substitutions required to make one string equal to another.

extension String {
    func levenshteinDistance(to target: String) -> Int {
        let sCount = self.count
        let tCount = target.count

        if sCount == 0 {
            return tCount
        }
        if tCount == 0 {
            return sCount
        }

        var matrix = Array(repeating: Array(repeating: 0, count: tCount + 1), count: sCount + 1)

        for i in 0...sCount {
            matrix[i][0] = i
        }

        for j in 0...tCount {
            matrix[0][j] = j
        }

        for i in 1...sCount {
            for j in 1...tCount {
                let cost = self[self.index(self.startIndex, offsetBy: i - 1)] == target[target.index(target.startIndex, offsetBy: j - 1)] ? 0 : 1
                matrix[i][j] = Swift.min(
                    matrix[i - 1][j] + 1, // Deletion
                    matrix[i][j - 1] + 1, // Insertion
                    matrix[i - 1][j - 1] + cost // Substitution
                )
            }
        }

        return matrix[sCount][tCount]
    }
}
