//
//  Query+Listener.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 28..
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

extension Query {
    func addSnapSnotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T: Decodable {
        let publisher = PassthroughSubject<[T], Error>() // Just listening for values

        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                return
            }
            let products: [T] = documents.compactMap{try? $0.data(as: T.self)}
            publisher.send(products)
        }
        return (publisher.eraseToAnyPublisher(), listener)
    }
}
