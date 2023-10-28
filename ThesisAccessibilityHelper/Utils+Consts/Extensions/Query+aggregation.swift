//
//  Query+aggregation.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 28..
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

extension Query {
    func aggregationCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)

        return Int(truncating: snapshot.count)
    }
}
