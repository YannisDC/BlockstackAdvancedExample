//
//  PreOnboardingSingleViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 12/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Core

final class PreOnboardingSingleViewModel: ViewModel {

    private weak var coordinator: BaseCoordinator<PreOnboardingRoute>?
    private let usecase: AuthUseCase!
    private let initUseCase: InitUseCase!
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<PreOnboardingRoute>?,
         useCaseProvider: Core.UseCaseProvider) {
        self.coordinator = coordinator
        self.usecase = useCaseProvider.makeAuthUseCase()
        self.initUseCase = useCaseProvider.makeInitUseCase()
    }

    // MARK: Transform

    func transform(input: PreOnboardingSingleViewModel.Input) -> PreOnboardingSingleViewModel.Output {
        let title = Driver.just("".localized())
        
        let continueButtonTap = input.buttonTap.do(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            
            self.usecase
                .signIn()
                .do(onSuccess: { (_) in
                    self.coordinator?.coordinate(to: .finished)
                }, onError: { (error) in
                    print(error)
                })
        })
        
        return Output(tapResult: continueButtonTap,
                      title: title)
    }
}

// MARK: - ViewModel

extension PreOnboardingSingleViewModel {
    struct Input {
        let buttonTap: Driver<Void>
    }
    
    struct Output {
        let tapResult: Driver<Void>
        let title: Driver<String>
    }
}
