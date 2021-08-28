//
//  LoginSignupViewModel.swift
//  Increment
//
//  Created by Tony Mu on 28/08/21.
//

import Foundation

final class LoginSignupViewModel: ObservableObject {
    private let mode: Mode
    @Published var emailText = ""
    @Published var passwordText = ""
    @Published var isValid = false
    
    init(mode: Mode) {
        self.mode = mode
    }
    
    var title: String {
        switch mode {
        case .login:
            return "Welcome back!"
        default:
            return "Create an account"
        }
    }
    
    var subtitle: String {
        switch mode {
        case .login:
            return "Log in with your email"
        default:
            return "Sign up via email"
        }
    }
    
    var buttonTitle: String {
        switch mode {
        case .login:
            return "Log in"
        default:
            return "Sign up"
        }
    }
}

extension LoginSignupViewModel {
    enum Mode {
        case login
        case singup
    }
}
