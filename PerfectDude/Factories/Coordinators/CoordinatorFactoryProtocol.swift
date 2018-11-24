//
//  CoordinatorFactoryProtocol.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 01/11/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import Core

protocol CoordinatorFactoryProtocol {
    
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
                             usecaseProvider: Core.UseCaseProvider) -> HomeCoordinator
    
    
    /// Creates a LikesCoordinator
    ///
    /// - Parameters:
    ///   - rootViewController: BaseViewController instance
    ///   - delegate: CoordinatorDelegate instance
    ///   - factory: ControllerFactory instance
    ///   - usecaseProvider: UseCaseProvider instance
    /// - Returns: LikesCoordinator instance
    func makeLikesCoordinator(rootViewController: BaseViewController,
                              delegate: CoordinatorDelegate?,
                              factory: ControllerFactory,
                              usecaseProvider: Core.UseCaseProvider) -> LikesCoordinator
}
