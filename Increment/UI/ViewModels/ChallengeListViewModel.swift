//
//  ChallengeListViewModel.swift
//  Increment
//
//  Created by Tony Mu on 9/08/21.
//

import Foundation
import Combine

final class ChallengeListViewModel: ObservableObject {
    private let userService: UserServiceProtocol
    private let challengeService: ChallengeServiceProtocol
    private var cancellable: [AnyCancellable] = []
    @Published private(set) var itemViewModels: [ChallengeItemViewModel] = []
    let title = "Challenges" 
    
    init(userService: UserServiceProtocol = UserService(), challengeService: ChallengeServiceProtocol = ChallengeService()) {
        self.userService = userService
        self.challengeService = challengeService
        observeChallenges()
    }
    
    private func observeChallenges() {
        userService.currentUser()
            .compactMap { $0?.uid }
            .flatMap { userId -> AnyPublisher<[Challenge], IncrementError> in
                return self.challengeService.observeChallenges(userId: userId)
            }.sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("Finished")
                }
            } receiveValue: { challenges in
                self.itemViewModels = challenges.map {.init($0)}
            }.store(in: &cancellable)

    }
}
