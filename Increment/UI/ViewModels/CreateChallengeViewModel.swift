//
//  CreateChallengeViewModel.swift
//  Increment
//
//  Created by Tony Mu on 19/07/21.
//

import SwiftUI
import Combine

typealias UserId = String

final class CreateChallengeViewModel: ObservableObject {
    private let userService: UserServiceProtocol
    private let challengeService: ChallengeServiceProtocol
    private var cancellable: [AnyCancellable] = []
    
    @Published var execriseDropdown = ChallengePartViewModel(type: .execrise)
    @Published var startAmountDropdown = ChallengePartViewModel(type: .startAmount)
    @Published var increaseDropdown = ChallengePartViewModel(type: .increase)
    @Published var lengthDropdown = ChallengePartViewModel(type: .length)

    @Published var error: IncrementError?
    @Published var isLoading: Bool = false
    
    enum Action {
        case createChallenge
    }
    
    init(userService: UserServiceProtocol = UserService(),
         challengeService: ChallengeServiceProtocol = ChallengeService()) {
        self.userService = userService
        self.challengeService = challengeService
    }
    
    func send(action: Action) {
        switch action {
        case .createChallenge:
            isLoading = true
            currentUserId().flatMap { userId -> AnyPublisher<Void, IncrementError> in
                self.createChallenge(userId: userId)
            }.sink { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished:
                    print("Finished")
                }
            } receiveValue: { _ in
                print("Success")
            }.store(in: &cancellable)
        }
    }
    
    private func createChallenge(userId: UserId) -> AnyPublisher<Void, IncrementError> {
        guard let execrise = execriseDropdown.text,
              let startAmount = startAmountDropdown.number,
              let increase = increaseDropdown.number,
              let length = lengthDropdown.number else {
            return Fail(error: .default(description: "Unable to get selected value")).eraseToAnyPublisher()
        }
        
        let challenge = Challenge(exercise: execrise,
                                  startAmount: startAmount,
                                  increase: increase,
                                  length: length,
                                  userId: userId,
                                  startDate: Date())
        return challengeService.create(challenge)
    }
    
    private func currentUserId() -> AnyPublisher<UserId, IncrementError> {
        return userService.currentUser().flatMap { user -> AnyPublisher<UserId, IncrementError> in
            if let userId = user?.uid {
                return Just(userId)
                    .setFailureType(to: IncrementError.self)
                    .eraseToAnyPublisher()
            } else {
                return self.userService // ? weak self?
                    .signInAnonymously()
                    .map{$0.uid}
                    .eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
}


extension CreateChallengeViewModel {
    
    struct ChallengePartViewModel: DropdownItemProtocol {
        var selectedOption: DropdownOption
        
        private let type: ChallengePartType
        
        var options: [DropdownOption] = []
        
        var headerTitle: String {
            type.rawValue
        }
        
        var dropdownTitle: String {
            selectedOption.formatted
        }
        
        var isSelected: Bool = false
        
        init(type: ChallengePartType) {
            self.type = type
            switch type {
            case .execrise:
                self.options = ExecridseOption.allCases.map { $0.toDropdownOption }
            case .startAmount:
                self.options = StartOption.allCases.map { $0.toDropdownOption }
            case .increase:
                self.options = IncreaseOption.allCases.map { $0.toDropdownOption }
            case .length:
                self.options = LengthOption.allCases.map { $0.toDropdownOption }
            }
            self.selectedOption = options.first!
        }
        
        enum ChallengePartType: String, CaseIterable {
            case execrise = "Execridse"
            case startAmount = "Starting Amount"
            case increase = "Daily Increase"
            case length = "Challenge Length"
        }
        
        enum ExecridseOption: String, CaseIterable, DropdownOptionProtocol {
            case pullups
            case pushups
            case situps
            
            var toDropdownOption: DropdownOption {
                DropdownOption(type: .text(rawValue),
                               formatted:rawValue.capitalized)
            }
        }
        
        enum StartOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
            
            var toDropdownOption: DropdownOption {
                DropdownOption(type: .number(rawValue),
                               formatted: "\(rawValue)")
            }
        }
        
        enum IncreaseOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
            
            var toDropdownOption: DropdownOption {
                DropdownOption(type: .number(rawValue),
                               formatted: "+\(rawValue)")
            }
        }
        
        enum LengthOption: Int, CaseIterable, DropdownOptionProtocol {
            case seven = 7, forteen = 14, twentyOne = 21, twentyEight = 28
            
            var toDropdownOption: DropdownOption {
                DropdownOption(type: .number(rawValue),
                               formatted: "\(rawValue) days")
            }
        }
        
    }
}

extension CreateChallengeViewModel.ChallengePartViewModel {
    var text: String? {
        if case let .text(text) = selectedOption.type {
            return text
        }
        return nil
    }
    
    var number: Int? {
        if case let .number(number) = selectedOption.type {
            return number
        }
        return nil
    }
}
