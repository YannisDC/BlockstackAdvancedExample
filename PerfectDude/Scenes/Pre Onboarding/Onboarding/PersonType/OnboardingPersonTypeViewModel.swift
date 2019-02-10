//
//  OnboardingPersonTypeViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 09/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa

final class OnboardingPersonTypeViewModel: ViewModel {

    private weak var coordinator: BaseCoordinator<PreOnboardingRoute>?
    private let profile: Profile

    // MARK: Init

    init(coordinator: BaseCoordinator<PreOnboardingRoute>?,
         profile: Profile) {
        self.coordinator = coordinator
        self.profile = profile
    }

    // MARK: Transform

    func transform(input: OnboardingPersonTypeViewModel.Input) -> OnboardingPersonTypeViewModel.Output {
        let title = Driver.just("".localized())

        let firstOptionTap = input.firstTrigger
            .do(onNext: { (_) in
                var profile = self.profile
                profile.personType = .donJuan
                self.coordinator?.coordinate(to: .relationshipStatus(profile: profile))
            })
        
        let secondOptionTap = input.secondTrigger
            .do(onNext: { (_) in
                var profile = self.profile
                profile.personType = .playItCool
                self.coordinator?.coordinate(to: .relationshipStatus(profile: profile))
            })
        
        let thirdOptionTap = input.thirdTrigger
            .do(onNext: { (_) in
                var profile = self.profile
                profile.personType = .iDontCare
                self.coordinator?.coordinate(to: .relationshipStatus(profile: profile))
            })
        
        let selectionResult = Driver.merge(firstOptionTap,
                                           secondOptionTap,
                                           thirdOptionTap)
        
        return Output(title: title,
                      selectionResult: selectionResult)
    }
}

// MARK: - ViewModel

extension OnboardingPersonTypeViewModel {
    struct Input {
        let firstTrigger: Driver<Void>
        let secondTrigger: Driver<Void>
        let thirdTrigger: Driver<Void>
    }

    struct Output {
        let title: Driver<String>
        let selectionResult: Driver<Void>
    }
}
