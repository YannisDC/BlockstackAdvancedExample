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
    private let authUseCase: AuthUseCase!
    private let initUseCase: InitUseCase!
    private let profileUseCase: ProfileUseCase!

    // MARK: Init

    init(coordinator: BaseCoordinator<PreOnboardingRoute>?,
         useCaseProvider: Core.UseCaseProvider) {
        self.coordinator = coordinator
        self.authUseCase = useCaseProvider.makeAuthUseCase()
        self.initUseCase = useCaseProvider.makeInitUseCase()
        self.profileUseCase = useCaseProvider.makeProfileUseCase()
    }

    // MARK: Transform

    func transform(input: PreOnboardingViewModel.Input) -> PreOnboardingViewModel.Output {
        let title = Driver.just("".localized())
        
        let pinButtonTap = input.buttonTap.do(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            
            self.profileUseCase
                .getProfile()
                .subscribe(onSuccess: { (profile) in
                    self.coordinator?.coordinate(to: .finished)
                }, onError: { (error) in
                    print("no profile yet")
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

extension PreOnboardingViewModel {
    
    private func checkProfile() -> Completable {
        return Completable.create { completable in
            self.profileUseCase
                .getProfile()
                .subscribe(onSuccess: { (profile) in
                    self.coordinator?.coordinate(to: .finished)
                    completable(.completed)
                }, onError: { (error) in
                    self.coordinator?.coordinate(to: .overview)
                    completable(.completed)
                })
            return Disposables.create {}
        }
    }
}
