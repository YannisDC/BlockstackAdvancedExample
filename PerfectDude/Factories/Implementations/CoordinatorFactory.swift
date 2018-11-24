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
                             usecaseProvider: Core.UseCaseProvider) -> HomeCoordinator {
        
        return HomeCoordinator(rootViewController: rootViewController,
                               delegate: delegate,
                               factory: factory,
                               usecaseProvider: usecaseProvider)
        
    }
    
    
    func makeLikesCoordinator(rootViewController: BaseViewController,
                             delegate: CoordinatorDelegate?,
                             factory: ControllerFactory,
                             usecaseProvider: Core.UseCaseProvider) -> LikesCoordinator {
        
        return LikesCoordinator(rootViewController: rootViewController,
                               delegate: delegate,
                               factory: factory,
                               usecaseProvider: usecaseProvider)
        
    }
}
