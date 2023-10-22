//
//  Query+getDocumentAs.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 22..
//

import FirebaseFirestoreSwift
import FirebaseFirestore
import Foundation

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        let snapshot = try await self.getDocuments()

        return try snapshot.documents.map { documentSnapshot in
            try documentSnapshot.data(as: T.self)
        }
    }
}
