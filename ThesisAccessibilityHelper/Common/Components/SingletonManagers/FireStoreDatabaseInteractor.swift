//
//  FireStoreDatabaseInteractor.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class FireStoreDatabaseInteractor {
    // MARK: - Types

    private struct Consts {
        static let helperCollection = "helper_users"
        static let imparedCollection = "impared_users"
    }

    // MARK: - Properties

    static let shared = FireStoreDatabaseInteractor()

    private let helperCollection = Firestore.firestore().collection(Consts.helperCollection)
    private let imparedCollection = Firestore.firestore().collection(Consts.imparedCollection)

    // MARK: - Initialization

    private init() {
    }

    // MARK: - Functions

    func createUser(user: UserModelInput) async {
        switch user.type {
            case .helper:
                try? await registerHelper(user: (user as! HelperUserModel))
            case .impared:
                try? await registerImpared(user: (user as! ImparedUserModel))
        }
    }

    private func registerHelper(user: HelperUserModel) async throws {
        try helperCollection.document(user.userID).setData(from: user, merge: true) { [weak self] error in
            print(error)
        }
    }

    private func registerImpared(user: ImparedUserModel) async throws {
        try imparedCollection.document(user.userID).setData(from: user, merge: true) { [weak self] error in
            print(error)
        }
    }
}
