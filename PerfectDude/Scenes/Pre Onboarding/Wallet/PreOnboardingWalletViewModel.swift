//
//  PreOnboardingWalletViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 06/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class PreOnboardingWalletViewModel: ViewModel {

    private weak var coordinator: BaseCoordinator<PreOnboardingRoute>?

    // MARK: Init

    init(coordinator: BaseCoordinator<PreOnboardingRoute>?) {
        self.coordinator = coordinator
    }

    // MARK: Transform

    func transform(input: PreOnboardingWalletViewModel.Input) -> PreOnboardingWalletViewModel.Output {
        let title = Driver.just("".localized())

        return Output(title: title)
    }
}

// MARK: - ViewModel

extension PreOnboardingWalletViewModel {
    struct Input {
    }

    struct Output {
        let title: Driver<String>
    }
}
