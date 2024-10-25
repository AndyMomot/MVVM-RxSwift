//
//  LoginViewModel.swift
//  MVVM+RxSwift
//
//  Created by Andrii Momot on 25.10.2024.
//

import Foundation
import RxSwift
import RxCocoa

let user = UserModel(fullName: "Steve Jobs", login: "user", password: "12345")

final class LoginViewModel {
    // INPUTS
    let loginText = BehaviorRelay(value: "")
    let passwordText = BehaviorRelay(value: "")
    
    // OUTPUTS
    let messageText = BehaviorRelay<String?>(value: nil)
    let goToHomeController = PublishSubject<Void>()
    let triggerAlert = PublishSubject<Void>()
    
    // METHODS
    func validate() {
        if loginText.value.isEmpty && passwordText.value.isEmpty {
            messageText.accept("Enter email & password")
        } else if loginText.value.isEmpty {
            messageText.accept("Enter email")
        } else if passwordText.value.isEmpty {
            messageText.accept("Enter password")
        } else {
            if loginText.value == user.login && passwordText.value == user.password {
                goToHomeController.onNext(())
            } else {
                triggerAlert.onNext(())
            }
        }
    }
}
