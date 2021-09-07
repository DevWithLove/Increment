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
    @Published private(set) var error: IncrementError?
    @Published private(set) var isLoading = false
    @Published var showingCreateModal = false
    let title = "Challenges"
    
    enum Action {
        case retry
        case create
        case timeChange
    }
    
    init(userService: UserServiceProtocol = UserService(), challengeService: ChallengeServiceProtocol = ChallengeService()) {
        self.userService = userService
        self.challengeService = challengeService
        observeChallenges()
    }
    
    private func observeChallenges() {
        isLoading = true
        userService.currentUserPublisher()
            .compactMap { $0?.uid }
            .flatMap { [weak self] userId -> AnyPublisher<[Challenge], IncrementError> in
                guard let self = self else { return Fail(error: .default()).eraseToAnyPublisher() }
                return self.challengeService.observeChallenges(userId: userId)
            }.sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case let .failure(error):
                    self.error = error
                    print(error.localizedDescription)
                case .finished:
                    print("Finished")
                }
            } receiveValue: { [weak self] challenges in
                guard let self = self else { return }
                self.isLoading = false
                self.error = nil
                self.showingCreateModal = false
                self.itemViewModels = challenges.map { challenge in
                    .init(challenge,
                          onDelete: { [weak self] id in
                            self?.deleteChallenge(id)
                          },
                          onToggleComplete: { [weak self] id, activities in
                            self?.updateChallenge(id: id, activities: activities)
                          }
                    )}
            }.store(in: &cancellable)
    }
    
    private func deleteChallenge(_ challengeId: String) {
        challengeService.delete(challengeId).sink { completeion in
            switch completeion {
            case let .failure(error):
                print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: { _ in
        }.store(in: &cancellable)
    }
    
    private func updateChallenge(id: String, activities: [Activity] ) {
        challengeService.update(id, activities: activities).sink { completeion in
            switch completeion {
            case let .failure(error):
                print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: { _ in
        }.store(in: &cancellable)
    }
    
    func send(action: Action) {
        switch action {
        case .retry:
            observeChallenges()
        case .create:
            showingCreateModal = true
        case .timeChange:
            cancellable.removeAll()
            observeChallenges()
        }
    }
}
