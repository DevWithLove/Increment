//
//  SettingsItemViewModel.swift
//  Increment
//
//  Created by Tony Mu on 24/08/21.
//


extension SettingsViewModel {
    struct SettingsItemViewModel {
        let title: String
        let iconName: String
        let type: SettingsItemType
    }
    
    enum SettingsItemType {
        case account
        case mode
        case privacy
        case logout
    }
}

