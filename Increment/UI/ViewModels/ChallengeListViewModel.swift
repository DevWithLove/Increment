//
//  ChallengeListViewModel.swift
//  Increment
//
//  Created by Tony Mu on 9/08/21.
//

import Foundation

final class ChallengeListViewModel: ObservableObject {
    private let userService: UserServiceProtocol
    private let challengeService: ChallengeServiceProtocol
    
    init(userService: UserServiceProtocol, challengeService: ChallengeServiceProtocol) {
        self.userService = userService
        self.challengeService = challengeService
    }
}
