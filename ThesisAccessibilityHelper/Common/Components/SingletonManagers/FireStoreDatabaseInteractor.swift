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

/// The interactor that manages the backend CRUD requests
@MainActor
final class FireStoreDatabaseInteractor {
    // MARK: - Types

    private struct Consts {
        static let helperCollection = "helper_users"
        static let imparedCollection = "impared_users"
    }

    struct FSDBCodingKeys {
        enum Coordinates: String, CodingKey {
            case longitude
            case latitude
        }
    }

    fileprivate typealias CodingKeys = FSDBCodingKeys

    // MARK: - Properties

    static let shared = FireStoreDatabaseInteractor()

    private(set) var cachedUser: UserModelInput?

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

    func updateCoordinates(for dataRes: AuthenticationDataResult, coordinates: (la: Double, lo: Double)) async {
        guard let user = try? await getUserBased(on: dataRes.uid) else { return }

        let collectionRefence: CollectionReference = user is HelperUserModel ? helperCollection : imparedCollection

        let data = [
            CodingKeys.Coordinates.latitude.rawValue: coordinates.la,
            CodingKeys.Coordinates.longitude.rawValue: coordinates.lo
        ]

        try? await collectionRefence.document(dataRes.uid).setData(data, merge: true)
    }

    func fetchHelpers() async throws -> [HelperUserModel] {
        let query: Query = self.getAllHelperUsersQuery()

        return try await query
            .getDocuments(as: HelperUserModel.self)
    }

    func fetchImpared() async throws -> [ImparedUserModel] {
        let query: Query = self.getAllImparedUsersQuery()

        return try await query
            .getDocuments(as: ImparedUserModel.self)
    }

    func getUserBased(on userID: String) async throws -> UserModelInput? {
        if let user = try? await getHelperAccount(userID: userID) {
            cachedUser = user
            return user
        } else if let user = try? await getImparedAccount(userID: userID) {
            cachedUser = user
            return user
        }
        return nil
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

    private func getHelperAccount(userID: String) async throws -> UserModelInput {
        try await helperCollection.document(userID).getDocument(as: HelperUserModel.self)
    }

    private func getImparedAccount(userID: String) async throws -> UserModelInput {
        try await imparedCollection.document(userID).getDocument(as: ImparedUserModel.self)
    }

    private func getAllHelperUsersQuery() -> Query {
        helperCollection
    }

    private func getAllImparedUsersQuery() -> Query {
        imparedCollection
    }
}
