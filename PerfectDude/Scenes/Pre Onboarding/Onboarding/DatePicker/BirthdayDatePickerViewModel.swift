//
//  BirthdayDatePickerViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 09/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa

final class BirthdayDatePickerViewModel: BaseDatePickerViewModel {

    private weak var coordinator: BaseCoordinator<PreOnboardingRoute>?
    private let profile: Profile
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<PreOnboardingRoute>?,
         profile: Profile) {
        self.coordinator = coordinator
        self.profile = profile
    }

    // MARK: Transform

    override func transform(input: Input) -> Output {
        let title = Driver.just("When is her birthday?".localized())
        
        let continueButtonTitle = Driver.just("".localized())
        
        let continueResult = input.continueTrigger
            .withLatestFrom(input.selection)
            .map { (date) in
                var profile = self.profile
                profile.birthday = date
                self.coordinator?.coordinate(to: .anniversary(profile: profile))
            }

        return Output(title: title,
                      continueButtonTitle: continueButtonTitle,
                      continueResult: continueResult)
    }
}
