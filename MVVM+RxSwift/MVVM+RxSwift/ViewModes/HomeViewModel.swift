//
//  HomeViewModel.swift
//  MVVM+RxSwift
//
//  Created by Andrii Momot on 25.10.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    // Outputs
    let fullNameText = BehaviorRelay<String?>(value: nil)
    
    func getUser() {
        let fullName = user.fullName
        fullNameText.accept(fullName)
    }
}
