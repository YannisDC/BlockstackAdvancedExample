//
//  TargetWeightViewModel.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 17/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TargetWeightViewModel: ViewModel {
    
    private weak var coordinator: BaseCoordinator<GoalRoute>?
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<GoalRoute>?) {
        self.coordinator = coordinator
    }
    
    // MARK: Transform
    
    func transform(input: TargetWeightViewModel.Input) -> TargetWeightViewModel.Output {
        let title = Driver.just("onboarding_set_your_pin_title".localized())
        let pinButtonTap = input.buttonTap.do(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.coordinator?.coordinate(to: .personalInformation)
        })
        
        return Output(tapResult: pinButtonTap,
                      title: title)
    }
}

// MARK: - ViewModel

extension TargetWeightViewModel {
    struct Input {
        let buttonTap: Driver<Void>
    }
    
    struct Output {
        let tapResult: Driver<Void>
        let title: Driver<String>
    }
}
