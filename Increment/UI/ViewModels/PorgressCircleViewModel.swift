//
//  PorgressCircleViewModel.swift
//  Increment
//
//  Created by Tony Mu on 2/09/21.
//

import Foundation

struct ProgressCircleViewModel {
    let title: String
    let message: String
    let percentageComplete: Double
    var shouldShowTitle: Bool {
       return percentageComplete <= 1
    }
}
