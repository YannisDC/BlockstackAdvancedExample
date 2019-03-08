//
//  ControllerFactory.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 01/11/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import Core
import RxSwift

final
class ControllerFactory: AppFactory,
    PreOnboardingFactory,
    HomeFactory,
    LikesFactory,
    CalendarEventsFactory
{
    
    // MARK: - AppFactory methods
    
    /// Creates an AuthenticationViewController
    ///
    /// Authenticates the user using a platform of choice.
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<AppRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    /// - Returns: AuthenticationViewController instance
    func makeAuthenticationViewController(coordinator: BaseCoordinator<AppRoute>,
                                          useCaseProvider: Core.UseCaseProvider) -> AuthenticationViewController {
        
        let authViewController = AuthenticationViewController.loadFromNib()
        let authViewModel = AuthenticationViewModel(coordinator: coordinator, useCaseProvider: useCaseProvider)
        
        authViewController.bindViewModel(to: authViewModel)
        return authViewController
        
    }
    
    /// Creates a PreOnboardingViewController
    ///
    /// Is a container for onboarding screens that inform the user about Blockstacks capabilities.
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<PreOnboardingRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    ///   - viewControllers: [UIViewController] instance
    /// - Returns: PreOnboardingViewController instance
    func makePreOnboardingViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                         useCaseProvider: Core.UseCaseProvider,
                                         viewControllers: [UIViewController]) -> PreOnboardingViewController {
        
        let preOnboardingViewController = PreOnboardingViewController(viewControllers: viewControllers)
        let preOnboardingViewModel = PreOnboardingViewModel(coordinator: coordinator,
                                                            useCaseProvider: useCaseProvider)
        
        preOnboardingViewController.bindViewModel(to: preOnboardingViewModel)
        return preOnboardingViewController
        
    }
    
    /// Creates a PreOnboardingIdentityViewController
    ///
    /// Is an embedded onboarding screen that informs the user about Blockstack identity.
    ///
    /// - Parameter coordinator: BaseCoordinator<PreOnboardingRoute> instance
    /// - Returns: PreOnboardingIdentityViewController instance
    func makePreOnboardingIdentityViewController(coordinator: BaseCoordinator<PreOnboardingRoute>) -> PreOnboardingIdentityViewController {
        
        let identityViewController = PreOnboardingIdentityViewController.loadFromNib()
        let identityViewModel = PreOnboardingIdentityViewModel(coordinator: coordinator)
        
        identityViewController.bindViewModel(to: identityViewModel)
        return identityViewController
        
    }
    
    /// Creates a PreOnboardingStorageViewController
    ///
    /// Is an embedded onboarding screen that informs the user about Blockstack storage.
    ///
    /// - Parameter coordinator: BaseCoordinator<PreOnboardingRoute> instance
    /// - Returns: PreOnboardingStorageViewController instance
    func makePreOnboardingStorageViewController(coordinator: BaseCoordinator<PreOnboardingRoute>) -> PreOnboardingStorageViewController {
        
        let storageViewController = PreOnboardingStorageViewController.loadFromNib()
        let storageViewModel = PreOnboardingStorageViewModel(coordinator: coordinator)
        
        storageViewController.bindViewModel(to: storageViewModel)
        return storageViewController
        
    }
    
    /// Creates a PreOnboardingWalletViewController
    ///
    /// Is an embedded onboarding screen that informs the user about Blockstack wallet.
    ///
    /// - Parameter coordinator: BaseCoordinator<PreOnboardingRoute> instance
    /// - Returns: PreOnboardingWalletViewController instance
    func makePreOnboardingWalletViewController(coordinator: BaseCoordinator<PreOnboardingRoute>) -> PreOnboardingWalletViewController {
        
        let walletViewController = PreOnboardingWalletViewController.loadFromNib()
        let walletViewModel = PreOnboardingWalletViewModel(coordinator: coordinator)
        
        walletViewController.bindViewModel(to: walletViewModel)
        return walletViewController
        
    }
    
    
    /// Creates a PreOnboardingSingleViewController
    ///
    /// Is an all-in-one onboarding screen that informs the user about Blockstack identity, storage and wallet.
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<PreOnboardingRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    /// - Returns: PreOnboardingSingleViewController instance
    func makePreOnboardingSingleViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                               useCaseProvider: Core.UseCaseProvider,
                                               profile: Profile) -> PreOnboardingSingleViewController {
        
        let singleViewController = PreOnboardingSingleViewController.loadFromNib()
        let singleViewModel = PreOnboardingSingleViewModel(coordinator: coordinator,
                                                           useCaseProvider: useCaseProvider,
                                                           profile: profile)
        
        singleViewController.bindViewModel(to: singleViewModel)
        return singleViewController
        
    }
    
    func makeOnboardingPersonTypeViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                                profile: Profile) -> OnboardingPersonTypeViewController {
        
        let viewController = OnboardingPersonTypeViewController.loadFromNib()
        let viewModel = OnboardingPersonTypeViewModel(coordinator: coordinator,
                                                      profile: profile)
        
        viewController.bindViewModel(to: viewModel)
        return viewController
        
    }
    
    func makeOnboardingRelationshipStatusViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                                        profile: Profile) -> OnboardingRelationshipStatusViewController {
        
        let viewController = OnboardingRelationshipStatusViewController.loadFromNib()
        let viewModel = OnboardingRelationshipStatusViewModel(coordinator: coordinator,
                                                              profile: profile)
        
        viewController.bindViewModel(to: viewModel)
        return viewController
        
    }
    
    func makeOnboardingBirthdayViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                              profile: Profile) -> OnboardingDatePickerViewController {
        
        let viewController = OnboardingDatePickerViewController.loadFromNib()
        let viewModel = BirthdayDatePickerViewModel(coordinator: coordinator,
                                                    profile: profile)
        
        viewController.bindViewModel(to: viewModel)
        return viewController
        
    }
    
    func makeOnboardingAnniversaryViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                                 profile: Profile,
                                                 useCaseProvider: Core.UseCaseProvider) -> OnboardingDatePickerViewController {
        
        let viewController = OnboardingDatePickerViewController.loadFromNib()
        let viewModel = AnniversaryDatePickerViewModel(coordinator: coordinator,
                                                       profile: profile,
                                                       useCaseProvider: useCaseProvider)
        
        viewController.bindViewModel(to: viewModel)
        return viewController
        
    }
    
    // MARK: - HomeFactory methods
    
    /// Creates a HomeViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<HomeRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    /// - Returns: HomeViewController instance
    func makeHomeViewController(coordinator: BaseCoordinator<HomeRoute>,
                                useCaseProvider: Core.UseCaseProvider) -> HomeViewController {
        
        let homeViewController = HomeViewController.loadFromNib()
        let homeViewModel = HomeViewModel(coordinator: coordinator,
                                          useCaseProvider: useCaseProvider)
        homeViewController.bindViewModel(to: homeViewModel)
        return homeViewController
        
    }
    
    // MARK: - LikesFactory methods
    
    /// Creates a LikesViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<LikesRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    /// - Returns: LikesViewController instance
    func makeLikesViewController(coordinator: BaseCoordinator<LikesRoute>,
                                 useCaseProvider: Core.UseCaseProvider) -> LikesViewController {
        
        let likesViewController = LikesViewController.loadFromNib()
        let likesViewModel = LikesViewModel(coordinator: coordinator,
                                            useCaseProvider: useCaseProvider)
        
        likesViewController.bindViewModel(to: likesViewModel)
        return likesViewController
        
    }
    
    /// Creates a CreateLikeViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<LikesRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    ///   - imagesTrigger: PublishSubject<UIImage?> instance
    /// - Returns: CreateLikeViewController instance
    func makeCreateLikeViewController(coordinator: BaseCoordinator<LikesRoute>,
                                      useCaseProvider: Core.UseCaseProvider,
                                      imagesTrigger: PublishSubject<UIImage?>) -> CreateLikeViewController {
        
        let createLikeViewController = CreateLikeViewController.loadFromNib()
        let createLikeViewModel = CreateLikeViewModel(coordinator: coordinator,
                                                      useCaseProvider: useCaseProvider,
                                                      imagesTrigger: imagesTrigger)
        createLikeViewController.bindViewModel(to: createLikeViewModel)
        return createLikeViewController
        
    }
    
    /// Creates an EditLikeViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<LikesRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    ///   - imagesTrigger: PublishSubject<UIImage?> instance
    ///   - like: Like instance
    /// - Returns: EditLikeViewController instance
    func makeEditLikeViewController(coordinator: BaseCoordinator<LikesRoute>,
                                    useCaseProvider: Core.UseCaseProvider,
                                    imagesTrigger: PublishSubject<UIImage?>,
                                    like: Like) -> CreateLikeViewController {
        
        let editLikeViewController = CreateLikeViewController.loadFromNib()
        let editLikeViewModel = EditLikeViewModel(coordinator: coordinator,
                                                  useCaseProvider: useCaseProvider,
                                                  imagesTrigger: imagesTrigger,
                                                  like: like)
        editLikeViewController.bindViewModel(to: editLikeViewModel)
        return editLikeViewController
        
    }
    
    // MARK: - CalendarEventsFactory methods
    
    /// Creates a CalendarEventsViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<CalendarEventsRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    /// - Returns: CalendarEventsViewController
    func makeCalendarEventsViewController(coordinator: BaseCoordinator<CalendarEventsRoute>,
                                          useCaseProvider: Core.UseCaseProvider) -> CalendarEventsViewController {
        
        let calendarEventsViewController = CalendarEventsViewController.loadFromNib()
        let calendarEventsViewModel = CalendarEventsViewModel(coordinator: coordinator,
                                                              useCaseProvider: useCaseProvider)
        
        calendarEventsViewController.bindViewModel(to: calendarEventsViewModel)
        return calendarEventsViewController
        
    }
    
    /// Creates a CreateCalendarEventViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<CalendarEventsRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    /// - Returns: CreateCalendarEventViewController
    func makeCreateCalendarEventViewController(coordinator: BaseCoordinator<CalendarEventsRoute>,
                                               useCaseProvider: Core.UseCaseProvider) -> CreateCalendarEventViewController {
        
        let createCalendarEventViewController = CreateCalendarEventViewController.loadFromNib()
        let createCalendarEventViewModel = CreateCalendarEventViewModel(coordinator: coordinator,
                                                                        useCaseProvider: useCaseProvider)
        
        createCalendarEventViewController.bindViewModel(to: createCalendarEventViewModel)
        return createCalendarEventViewController
        
    }
    
    /// Creates an EditCalendarEventViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<CalendarEventsRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    ///   - event: CalendarEvent instance
    /// - Returns: EditCalendarEventViewController
    func makeEditCalendarEventViewController(coordinator: BaseCoordinator<CalendarEventsRoute>,
                                             useCaseProvider: Core.UseCaseProvider,
                                             event: CalendarEvent) -> CreateCalendarEventViewController {
        
        let editCalendarEventViewController = CreateCalendarEventViewController.loadFromNib()
        let editCalendarEventViewModel = EditCalendarEventViewModel(coordinator: coordinator,
                                                                    useCaseProvider: useCaseProvider,
                                                                    event: event)
        
        editCalendarEventViewController.bindViewModel(to: editCalendarEventViewModel)
        return editCalendarEventViewController
        
    }
    
}
