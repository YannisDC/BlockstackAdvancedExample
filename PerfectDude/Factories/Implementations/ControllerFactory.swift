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
    
    func makeLikesViewController(coordinator: BaseCoordinator<LikesRoute>) -> LikesViewController {
        
        let likesViewController = LikesViewController.loadFromNib()
        let likesViewModel = LikesViewModel(coordinator: coordinator)
        
        likesViewController.bindViewModel(to: likesViewModel)
        return likesViewController
        
    }
    
    func makeCreateLikeViewController(coordinator: BaseCoordinator<LikesRoute>,
                                      imagesTrigger: PublishSubject<UIImage?>) -> CreateLikeViewController {
        
        let createLikeViewController = CreateLikeViewController.loadFromNib()
        let createLikeViewModel = CreateLikeViewModel(coordinator: coordinator,
                                                      imagesTrigger: imagesTrigger)
        createLikeViewController.bindViewModel(to: createLikeViewModel)
        return createLikeViewController
        
    }
    
    func makeEditLikeViewController(coordinator: BaseCoordinator<LikesRoute>,
                                    imagesTrigger: PublishSubject<UIImage?>,
                                    like: Like) -> EditLikeViewController {
        
        let editLikeViewController = EditLikeViewController.loadFromNib()
        let editLikeViewModel = EditLikeViewModel(coordinator: coordinator,
                                                  like: like,
                                                  imagesTrigger: imagesTrigger)
        editLikeViewController.bindViewModel(to: editLikeViewModel)
        return editLikeViewController
        
    }
    
}
