//
//  PreOnboardingFactory.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 05/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import UIKit
import Core

protocol PreOnboardingFactory {
    /// Creates a PreOnboardingViewController
    ///
    /// - Parameters:
    /// - coordinator: BaseCoordinator<PreOnboardingRoute> instance
    /// - viewControllers: [UIViewController] instance
    /// - Returns: PreOnboardingViewController instance
    func makePreOnboardingViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                         useCaseProvider: Core.UseCaseProvider,
                                         viewControllers: [UIViewController]) -> PreOnboardingViewController
    
    func makePreOnboardingIdentityViewController(coordinator: BaseCoordinator<PreOnboardingRoute>) -> PreOnboardingIdentityViewController
    
    func makePreOnboardingStorageViewController(coordinator: BaseCoordinator<PreOnboardingRoute>) -> PreOnboardingStorageViewController
    
    func makePreOnboardingWalletViewController(coordinator: BaseCoordinator<PreOnboardingRoute>) -> PreOnboardingWalletViewController
    
    func makePreOnboardingSingleViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                               useCaseProvider: Core.UseCaseProvider,
                                               profile: Profile) -> PreOnboardingSingleViewController
    
    func makeOnboardingPersonTypeViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                                profile: Profile) -> OnboardingPersonTypeViewController
    
    func makeOnboardingRelationshipStatusViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                                        profile: Profile) -> OnboardingRelationshipStatusViewController
    
    func makeOnboardingBirthdayViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                              profile: Profile) -> OnboardingDatePickerViewController
    
    func makeOnboardingAnniversaryViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                                 profile: Profile,
                                                 useCaseProvider: Core.UseCaseProvider) -> OnboardingDatePickerViewController
}
