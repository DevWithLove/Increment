//
//  LoginSignupViewModel.swift
//  Increment
//
//  Created by Tony Mu on 28/08/21.
//

import Combine
import SwiftUI

final class LoginSignupViewModel: ObservableObject {
    private let mode: Mode
    private let userService: UserServiceProtocol
    private var cancellables: [AnyCancellable] = []
    @Published var emailText = ""
    @Published var passwordText = ""
    @Published var isValid = false
    @Binding var isPushed: Bool
    
    init(mode: Mode,
         userService: UserServiceProtocol = UserService(),
         isPushed: Binding<Bool>) {
        self.mode = mode
        self.userService = userService
        self._isPushed = isPushed
        
        Publishers.CombineLatest($emailText, $passwordText).map { [weak self] email, password in
            return self?.isValidEmail(email)  == true && self?.isValidPassword(password) == true
        }.assign(to: &$isValid)
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
    
    func tappedActionButton() {
        switch mode {
        case .login:
            userService.login(email: emailText, password: passwordText).sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { _ in}
            .store(in: &cancellables)
        case .singup:
            userService.linkAccount(email: emailText, password: passwordText).sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    self?.isPushed = false
                    print("Finished")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
        }
    }
}

extension LoginSignupViewModel {
    enum Mode {
        case login
        case singup
    }
}

extension LoginSignupViewModel {
    func isValidEmail(_ email: String) -> Bool {
        // TODO:
        return email.count > 5
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count > 5
    }
}
