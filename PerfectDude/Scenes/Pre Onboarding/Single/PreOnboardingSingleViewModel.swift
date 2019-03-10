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
    private let authUseCase: AuthUseCase!
    private let initUseCase: InitUseCase!
    private let profileUseCase: ProfileUseCase!
    private let profile: Profile
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<PreOnboardingRoute>?,
         useCaseProvider: Core.UseCaseProvider,
         profile: Profile) {
        self.coordinator = coordinator
        self.authUseCase = useCaseProvider.makeAuthUseCase()
        self.initUseCase = useCaseProvider.makeInitUseCase()
        self.profileUseCase = useCaseProvider.makeProfileUseCase()
        self.profile = profile
    }

    // MARK: Transform

    func transform(input: PreOnboardingSingleViewModel.Input) -> PreOnboardingSingleViewModel.Output {
        let title = Driver.just("".localized())
        
        let continueButtonTap = input.buttonTap
            .flatMap({ [weak self] (_) -> Driver<Void> in
            guard let `self` = self else { return Driver.empty() }
            
            return self.signIn()
                .andThen(self.checkProfile())
                .asDriver(onErrorDriveWith: .empty())
                .mapToVoid()
        })
        
        return Output(tapResult: continueButtonTap,
                      title: title,
                      firstStepViewTitle: Driver<String>.just("test"))
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
        let firstStepViewTitle: Driver<String>
    }
}

extension PreOnboardingSingleViewModel {
    private func signIn() -> Completable {
        return Completable.create { completable in
            self.authUseCase
                .signIn()
                .subscribe(onSuccess: { (_) in
                    completable(.completed)
                }, onError: { (error) in
                    completable(.error(CoreError.general))
                })
            return Disposables.create {}
        }
    }
    
    private func checkProfile() -> Completable {
        return Completable.create { completable in
            self.profileUseCase
                .getProfile()
                .subscribe(onSuccess: { (profile) in
                    self.coordinator?.coordinate(to: .finished)
                    completable(.completed)
                }, onError: { (error) in
                    self.coordinator?.coordinate(to: .personType(profile: self.profile))
                    completable(.completed)
                })
            return Disposables.create {}
        }
    }
}
