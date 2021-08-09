//
//  QuerySnapshotPublisher.swift
//  Increment
//
//  Created by Tony Mu on 9/08/21.
//

import Combine
import Firebase

extension Publishers {
    struct QuerySnapshotPublisher: Publisher {
        typealias Output = QuerySnapshot
        typealias Failure = IncrementError
        
        private let query: Query
        
        init(query: Query) { self.query = query}
        
        func receive<S>(subscriber: S) where S : Subscriber, IncrementError == S.Failure, Output == S.Input {
            let subscription = QuerySnapshotSubscription(subscriber: subscriber, query: query)
            subscriber.receive(subscription: subscription)
        }
    }
    
    class QuerySnapshotSubscription<S: Subscriber>: Subscription where S.Input == QuerySnapshot, S.Failure == IncrementError  {

        private var subscriber: S?
        private var listener: ListenerRegistration?
        
        init(subscriber: S, query: Query) {
            self.subscriber = subscriber
            self.listener = query.addSnapshotListener({ querySnapshot, error in
                if let error = error {
                    subscriber.receive(completion: .failure(.default(description: error.localizedDescription)))
                } else if let querySnapshot = querySnapshot {
                    _ = subscriber.receive(querySnapshot)
                } else {
                    subscriber.receive(completion: .failure(.default()))
                }
            })
        }
        
        func request(_ demand: Subscribers.Demand) {
        }
        
        func cancel() {
            self.subscriber = nil
            self.listener = nil
        }
    }
    
}
