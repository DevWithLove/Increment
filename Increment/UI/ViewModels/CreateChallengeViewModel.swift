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
    private var cancellable: [AnyCancellable] = []
    
    @Published var dropdowns: [ChallengePartViewModel] = [
        .init(type: .execrise),
        .init(type: .startAmount),
        .init(type: .increase),
        .init(type: .length)
    ]
    
    enum Action {
        case selectOption(index: Int)
        case createChallenge
    }
    
    var hasSelectedDropdown: Bool {
        selectedDropdownIndex != nil
    }
    var selectedDropdownIndex: Int? {
        dropdowns.enumerated().first(where: {$0.element.isSelected})?.offset
    }
    
    var displayedOptions: [DropdownOption] {
        guard let selectedIndex = selectedDropdownIndex else { return [] }
        return dropdowns[selectedIndex].options
    }
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func send(action: Action) {
        guard let selectedIndex = selectedDropdownIndex else { return }
        switch action {
        case .selectOption(let index):
            clearSelectedOption()
            dropdowns[selectedIndex].options[index].isSelected = true
            clearSelectedDropdown()
        case .createChallenge:
            currentUserId().sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("Completed")
                }
            } receiveValue: { userId in
                print("Reterived userId: \(userId)")
            }.store(in: &cancellable)
        }
    }
    
    func clearSelectedOption() {
        guard let selectedIndex = selectedDropdownIndex else { return }
        dropdowns[selectedIndex].options.indices.forEach({ index in
            dropdowns[selectedIndex].options[index].isSelected = false
        })
    }
    
    func clearSelectedDropdown() {
        guard let selectedIndex = selectedDropdownIndex else { return }
        dropdowns[selectedIndex].isSelected = false
    }
    
    private func currentUserId() -> AnyPublisher<UserId, Error> {
        return userService.currentUser().flatMap { user -> AnyPublisher<UserId, Error> in
            if let userId = user?.uid {
                return Just(userId)
                    .setFailureType(to: Error.self)
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
        private let type: ChallengePartType
        
        var options: [DropdownOption] = []
        
        var headerTitle: String {
            type.rawValue
        }
        
        var dropdownTitle: String {
            options.first(where: {$0.isSelected})?.formatted ?? ""
        }
        
        var isSelected: Bool = false
        
        init(type: ChallengePartType) {
            self.type = type
            self.options = getOptions()
        }
        
        
        private func getOptions() -> [DropdownOption] {
            switch type {
            case .execrise:
                return ExecridseOption.allCases.map { $0.toDropdownOption }
            case .startAmount:
                return StartOption.allCases.map { $0.toDropdownOption }
            case .increase:
                return IncreaseOption.allCases.map { $0.toDropdownOption }
            case .length:
                return LengthOption.allCases.map { $0.toDropdownOption }
            }
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
                               formatted:rawValue.capitalized,
                               isSelected: self == .pullups)
            }
        }
        
        enum StartOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
            
            var toDropdownOption: DropdownOption {
                DropdownOption(type: .number(rawValue),
                               formatted: "\(rawValue)",
                               isSelected: self == .one)
            }
        }
        
        enum IncreaseOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
            
            var toDropdownOption: DropdownOption {
                DropdownOption(type: .number(rawValue),
                               formatted: "+\(rawValue)",
                               isSelected: self == .one)
            }
        }
        
        enum LengthOption: Int, CaseIterable, DropdownOptionProtocol {
            case seven = 7, forteen = 14, twentyOne = 21, twentyEight = 28
            
            var toDropdownOption: DropdownOption {
                DropdownOption(type: .number(rawValue),
                               formatted: "\(rawValue) days",
                               isSelected: self == .seven)
            }
        }
        
    }
}
