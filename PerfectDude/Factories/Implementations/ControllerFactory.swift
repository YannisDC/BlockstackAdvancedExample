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
    
    // MARK: AppFactory methods
    
    /// Creates an AuthenticationViewController
    ///
    /// - Parameters:
    ///   - coordinator: coordinator description
    ///   - useCaseProvider: useCaseProvider description
    /// - Returns: return value description
    func makeAuthenticationViewController(coordinator: BaseCoordinator<AppRoute>,
                                          useCaseProvider: Core.UseCaseProvider) -> AuthenticationViewController {
        
        let authViewController = AuthenticationViewController.loadFromNib()
        let authViewModel = AuthenticationViewModel(coordinator: coordinator, useCaseProvider: useCaseProvider)
        
        authViewController.bindViewModel(to: authViewModel)
        return authViewController
        
    }
    
    func makePreOnboardingViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                         useCaseProvider: Core.UseCaseProvider,
                                         viewControllers: [UIViewController]) -> PreOnboardingViewController {
        
        let preOnboardingViewController = PreOnboardingViewController(viewControllers: viewControllers)
        let preOnboardingViewModel = PreOnboardingViewModel(coordinator: coordinator,
                                                            useCaseProvider: useCaseProvider)
        
        preOnboardingViewController.bindViewModel(to: preOnboardingViewModel)
        return preOnboardingViewController
        
    }
    
    func makePreOnboardingIdentityViewController(coordinator: BaseCoordinator<PreOnboardingRoute>) -> PreOnboardingIdentityViewController {
        
        let identityViewController = PreOnboardingIdentityViewController.loadFromNib()
        let identityViewModel = PreOnboardingIdentityViewModel(coordinator: coordinator)
        
        identityViewController.bindViewModel(to: identityViewModel)
        return identityViewController
        
    }
    
    func makePreOnboardingStorageViewController(coordinator: BaseCoordinator<PreOnboardingRoute>) -> PreOnboardingStorageViewController {
        
        let storageViewController = PreOnboardingStorageViewController.loadFromNib()
        let storageViewModel = PreOnboardingStorageViewModel(coordinator: coordinator)
        
        storageViewController.bindViewModel(to: storageViewModel)
        return storageViewController
        
    }
    
    func makePreOnboardingWalletViewController(coordinator: BaseCoordinator<PreOnboardingRoute>) -> PreOnboardingWalletViewController {
        
        let walletViewController = PreOnboardingWalletViewController.loadFromNib()
        let walletViewModel = PreOnboardingWalletViewModel(coordinator: coordinator)
        
        walletViewController.bindViewModel(to: walletViewModel)
        return walletViewController
        
    }
    
    func makePreOnboardingSingleViewController(coordinator: BaseCoordinator<PreOnboardingRoute>,
                                               useCaseProvider: Core.UseCaseProvider) -> PreOnboardingSingleViewController {
        
        let singleViewController = PreOnboardingSingleViewController.loadFromNib()
        let singleViewModel = PreOnboardingSingleViewModel(coordinator: coordinator,
                                                           useCaseProvider: useCaseProvider)
        
        singleViewController.bindViewModel(to: singleViewModel)
        return singleViewController
        
    }
    
    // MARK: HomeFactory methods
    
    func makeHomeViewController(coordinator: BaseCoordinator<HomeRoute>,
                                imagesTrigger: PublishSubject<UIImage?>) -> HomeViewController {
        
        let homeViewController = HomeViewController.loadFromNib()
        let homeViewModel = HomeViewModel(coordinator: coordinator,
                                          imagesTrigger: imagesTrigger)
        homeViewController.bindViewModel(to: homeViewModel)
        return homeViewController
        
    }
    
    // MARK: LikesFactory methods
    
    func makeLikesViewController(coordinator: BaseCoordinator<LikesRoute>,
                                 usecaseProvider: Core.UseCaseProvider) -> LikesViewController {
        
        let likesViewController = LikesViewController.loadFromNib()
        let likesViewModel = LikesViewModel(coordinator: coordinator,
                                            usecaseProvider: usecaseProvider)
        
        likesViewController.bindViewModel(to: likesViewModel)
        return likesViewController
        
    }
    
    func makeCreateLikeViewController(coordinator: BaseCoordinator<LikesRoute>,
                                      usecaseProvider: Core.UseCaseProvider,
                                      imagesTrigger: PublishSubject<UIImage?>) -> CreateLikeViewController {
        
        let createLikeViewController = CreateLikeViewController.loadFromNib()
        let createLikeViewModel = CreateLikeViewModel(coordinator: coordinator,
                                                      usecaseProvider: usecaseProvider,
                                                      imagesTrigger: imagesTrigger)
        createLikeViewController.bindViewModel(to: createLikeViewModel)
        return createLikeViewController
        
    }
    
    func makeEditLikeViewController(coordinator: BaseCoordinator<LikesRoute>,
                                    usecaseProvider: Core.UseCaseProvider,
                                    imagesTrigger: PublishSubject<UIImage?>,
                                    like: Like) -> EditLikeViewController {
        
        let editLikeViewController = EditLikeViewController.loadFromNib()
        let editLikeViewModel = EditLikeViewModel(coordinator: coordinator,
                                                  usecaseProvider: usecaseProvider,
                                                  imagesTrigger: imagesTrigger,
                                                  like: like)
        editLikeViewController.bindViewModel(to: editLikeViewModel)
        return editLikeViewController
        
    }
    
    // MARK: LikesFactory methods
    
    func makeCalendarEventsViewController(coordinator: BaseCoordinator<CalendarEventsRoute>,
                                          usecaseProvider: Core.UseCaseProvider) -> CalendarEventsViewController {
        
        let calendarEventsViewController = CalendarEventsViewController.loadFromNib()
        let calendarEventsViewModel = CalendarEventsViewModel(coordinator: coordinator,
                                                              usecaseProvider: usecaseProvider)
        
        calendarEventsViewController.bindViewModel(to: calendarEventsViewModel)
        return calendarEventsViewController
        
    }
    
    func makeCreateCalendarEventViewController(coordinator: BaseCoordinator<CalendarEventsRoute>,
                                          usecaseProvider: Core.UseCaseProvider) -> CreateCalendarEventViewController {
        
        let createCalendarEventViewController = CreateCalendarEventViewController.loadFromNib()
        let createCalendarEventViewModel = CreateCalendarEventViewModel(coordinator: coordinator,
                                                              usecaseProvider: usecaseProvider)
        
        createCalendarEventViewController.bindViewModel(to: createCalendarEventViewModel)
        return createCalendarEventViewController
        
    }
    
}
