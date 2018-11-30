//
//  AuthenticationViewModel.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SafariServices
import Core

final class AuthenticationViewModel: ViewModel {
    
    private weak var coordinator: BaseCoordinator<AppRoute>?
    private let usecase: AuthUseCase!
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<AppRoute>?,
         useCaseProvider: Core.UseCaseProvider) {
        self.coordinator = coordinator
        self.usecase = useCaseProvider.makeAuthUseCase()
    }
    
    // MARK: Transform
    
    func transform(input: AuthenticationViewModel.Input) -> AuthenticationViewModel.Output {
        let title = Driver.just("onboarding_set_your_pin_title".localized())
        
        let pinButtonTap = input.buttonTap.do(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.usecase
                .signIn()
                .subscribe(onSuccess: { (_) in
                    self.coordinator?.coordinate(to: .home)
                }, onError: { (error) in
                    print(error)
                })
        })
        
        return Output(tapResult: pinButtonTap,
                      title: title)
    }
}

// MARK: - ViewModel

extension AuthenticationViewModel {
    struct Input {
        let buttonTap: Driver<Void>
    }
    
    struct Output {
        let tapResult: Driver<Void>
        let title: Driver<String>
    }
}

