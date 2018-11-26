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
HomeFactory,
LikesFactory {
    
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
    
}
