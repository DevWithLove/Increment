//
//  SettingsViewModel.swift
//  Increment
//
//  Created by Tony Mu on 24/08/21.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Published private(set) var itemViewModels: [SettingsItemViewModel] = []
    @Published var loginSignupPushed = false
    let title = "Settings"
    
    func item(at index: Int) -> SettingsItemViewModel {
        itemViewModels[index]
    }
    
    func tappedItem(at index: Int) {
        switch item(at: index).type {
        case .account:
            loginSignupPushed = true
        case .mode:
            isDarkMode = !isDarkMode
        default:
            break
        }
    }
    
    private func buildItems() {
        itemViewModels = [
            .init(title: "Create Acocunt", iconName: "person.circle", type: .account),
            .init(title: "Switch to \(isDarkMode ? "Light" : "Dark") Mode", iconName: "lightbulb", type: .mode),
            .init(title: "Privacy Policy", iconName: "shield", type: .privacy)
        ]
    }
    
    func onAppear() {
        buildItems()
    }
}
