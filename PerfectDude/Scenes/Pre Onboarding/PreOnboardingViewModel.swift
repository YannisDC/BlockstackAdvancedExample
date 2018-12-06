//
//  PreOnboardingViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 05/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Core
import SafariServices

final class PreOnboardingViewModel: ViewModel {

    private weak var coordinator: BaseCoordinator<PreOnboardingRoute>?
    private let usecase: AuthUseCase!

    // MARK: Init

    init(coordinator: BaseCoordinator<PreOnboardingRoute>?,
         useCaseProvider: Core.UseCaseProvider) {
        self.coordinator = coordinator
        self.usecase = useCaseProvider.makeAuthUseCase()
    }

    // MARK: Transform

    func transform(input: PreOnboardingViewModel.Input) -> PreOnboardingViewModel.Output {
        let title = Driver.just("".localized())
        
        let pinButtonTap = input.buttonTap.do(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            
            self.usecase.signIn()
                .subscribe(onSuccess: { (_) in
                    self.coordinator?.coordinate(to: .finished)
                }, onError: { (error) in
                    print(error)
                })
        })

        return Output(tapResult: pinButtonTap,
                      title: title)
    }
}

// MARK: - ViewModel

extension PreOnboardingViewModel {
    struct Input {
        let buttonTap: Driver<Void>
    }

    struct Output {
        let tapResult: Driver<Void>
        let title: Driver<String>
    }
}
