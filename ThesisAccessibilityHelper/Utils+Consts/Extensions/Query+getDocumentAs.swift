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

    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (forms: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()

        let products =  try snapshot.documents.map({document in
            try document.data(as: T.self)
        })
        return (products, snapshot.documents.last)
    }
}
