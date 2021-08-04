//
//  DropdownItemProtocol.swift
//  Increment
//
//  Created by Tony Mu on 19/07/21.
//

import Foundation

protocol DropdownItemProtocol {
    var options: [DropdownOption] { get }
    var headerTitle: String { get }
    var dropdownTitle: String { get }
    var isSelected: Bool { get set }
    var selectedOption: DropdownOption { get set }
}

protocol DropdownOptionProtocol {
    var toDropdownOption: DropdownOption { get }
}

struct DropdownOption {
    enum DropdownOptionType {
        case text(String)
        case number(Int)
    }
    
    let type: DropdownOptionType
    let formatted: String
}
