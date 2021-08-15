//
//  ChallengeService.swift
//  Increment
//
//  Created by Tony Mu on 4/08/21.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ChallengeServiceProtocol {
    func create(_ challenge: Challenge) -> AnyPublisher<Void, IncrementError>
    func observeChallenges(userId: UserId) -> AnyPublisher<[Challenge], IncrementError>
}

final class ChallengeService: ChallengeServiceProtocol {
    private let db = Firestore.firestore()
    func create(_ challenge: Challenge) -> AnyPublisher<Void, IncrementError> {
        return Future<Void, IncrementError> { [weak self] promise in
            do {
                _ = try self?.db.collection("challenge").addDocument(from: challenge) { error in
                    if let error = error {
                        promise(.failure(.default(description: error.localizedDescription)))
                        return
                    }
                    promise(.success(()))
                }
            } catch {
                promise(.failure(.default(description: error.localizedDescription)))
            }
        }.eraseToAnyPublisher()
    }
    
    func observeChallenges(userId: UserId) -> AnyPublisher<[Challenge], IncrementError> {
        let query = db.collection("challenge").whereField("userId", isEqualTo: userId)
        return Publishers.QuerySnapshotPublisher(query: query)
            .flatMap { snapshot ->AnyPublisher<[Challenge], IncrementError> in
                do {
                    let challenges = try snapshot.documents.compactMap {
                        try $0.data(as: Challenge.self)
                    }
                    return Just(challenges)
                        .setFailureType(to: IncrementError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: IncrementError.default(description: "Parsing data")).eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
}
