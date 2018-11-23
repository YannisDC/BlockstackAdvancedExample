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

final class AuthenticationViewModel: ViewModel {
    
    private weak var coordinator: BaseCoordinator<AppRoute>?
    private var usecase = UseCaseProvider().blockstackUseCaseProvider.makeAuthUseCase()
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<AppRoute>?) {
        self.coordinator = coordinator
    }
    
    // MARK: Transform
    
    func transform(input: AuthenticationViewModel.Input) -> AuthenticationViewModel.Output {
        let title = Driver.just("onboarding_set_your_pin_title".localized())
        
        let pinButtonTap = input.buttonTap.do(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.usecase
                .signIn()
                .subscribe({ _ in
                    self.coordinator?.coordinate(to: .home)
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

