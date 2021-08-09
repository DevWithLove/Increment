//
//  IncrementApp.swift
//  Increment
//
//  Created by Tony Mu on 17/07/21.
//

import SwiftUI
import Firebase
import Combine

@main
struct IncrementApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                TabContainerView()
            } else {
                LandingView()
            }
         
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

class AppState: ObservableObject {
    @Published private(set) var isLoggedIn = false
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        
        userService.observeAuthChanges()
            .map{ $0 != nil }
            .assign(to: &$isLoggedIn)
    }
    
}
