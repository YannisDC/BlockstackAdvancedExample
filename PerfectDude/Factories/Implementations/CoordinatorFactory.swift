//
//  CoordinatorFactory.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 01/11/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import Core

final
class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    func makePreOnboardingCoordinator(rootViewController: BaseViewController,
                                      delegate: CoordinatorDelegate?,
                                      factory: ControllerFactory,
                                      useCaseProvider: Core.UseCaseProvider) -> PreOnboardingCoordinator {
        
        return PreOnboardingCoordinator(rootViewController: rootViewController,
                                        delegate: delegate,
                                        useCaseProvider: useCaseProvider,
                                        factory: factory)
    }
    
    /// Creates a HomeCoordinator
    ///
    /// - Parameters:
    ///   - rootViewController: BaseViewController instance
    ///   - delegate: CoordinatorDelegate instance
    ///   - factory: ControllerFactory instance
    /// - Returns: HomeCoordinator instance
    func makeHomeCoordinator(rootViewController: BaseViewController,
                             delegate: CoordinatorDelegate?,
                             factory: ControllerFactory,
                             useCaseProvider: Core.UseCaseProvider) -> HomeCoordinator {
        
        return HomeCoordinator(rootViewController: rootViewController,
                               delegate: delegate,
                               factory: factory,
                               useCaseProvider: useCaseProvider)
        
    }
    
    
    /// Creates a LikesCoordinator
    ///
    /// - Parameters:
    ///   - rootViewController: BaseViewController instance
    ///   - delegate: CoordinatorDelegate instance
    ///   - factory: ControllerFactory instance
    ///   - usecaseProvider: Core.UseCaseProvider instance
    /// - Returns: LikesCoordinator instance
    func makeLikesCoordinator(rootViewController: BaseViewController,
                              delegate: CoordinatorDelegate?,
                              factory: ControllerFactory,
                              useCaseProvider: Core.UseCaseProvider) -> LikesCoordinator {
        
        return LikesCoordinator(rootViewController: rootViewController,
                                delegate: delegate,
                                factory: factory,
                                useCaseProvider: useCaseProvider)
        
    }
}
