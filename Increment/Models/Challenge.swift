//
//  Challenge.swift
//  Increment
//
//  Created by Tony Mu on 4/08/21.
//

import Foundation

struct Challenge: Codable, Hashable {
    let exercise: String
    let startAmount: Int
    let increase: Int
    let length: Int
    let userId: String
    let startDate: Date
}
