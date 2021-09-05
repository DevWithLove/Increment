//
//  ChallengeItemViewModel.swift
//  Increment
//
//  Created by Tony Mu on 16/08/21.
//

import Foundation

struct ChallengeItemViewModel: Identifiable {
    private let challenge: Challenge
    
    var id: String {
        challenge.id!
    }
    
    var title: String {
        challenge.exercise.capitalized
    }
    
    var progressCircleViewModel: ProgressCircleViewModel {
        let dayNumber = daysFromStart + 1
        let title = "Day"
        let message = isComplete ? "Done" :  "\(dayNumber) of \(challenge.length)"
        return .init(title: title,
                     message: message,
                     percentageComplete: Double(dayNumber) / Double(challenge.length))
    }
    
    private var daysFromStart: Int {
        let startDate = Calendar.current.startOfDay(for: challenge.startDate)
        let toDate = Calendar.current.startOfDay(for: Date())
        
        guard let daysFromStart = Calendar.current.dateComponents([.day], from: startDate, to: toDate).day else {
            return 0
        }
        return abs(daysFromStart)
    }
    
    private var isComplete: Bool {
        daysFromStart - challenge.length >= 0
    }
    
    private let onDelete: (String) -> Void
    
    var statesText: String {
        guard !isComplete else { return "Done" }
        let dayNumber = daysFromStart + 1
        return "Day \(dayNumber) of \(challenge.length)"
    }
    
    var dailyIncreaseText: String {
        "\(challenge.increase) daily"
    }
    
    init(_ challenge: Challenge, onDelete: @escaping (String)-> Void) {
        self.challenge = challenge
        self.onDelete = onDelete
    }
    
    func tappedDelete() {
        guard let id = challenge.id else { return }
        onDelete(id)
    }
}
