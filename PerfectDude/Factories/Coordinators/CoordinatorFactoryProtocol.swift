//
//  CoordinatorFactoryProtocol.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 01/11/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation

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
                             usecaseProvider: UseCaseProvider) -> HomeCoordinator
    
    
    func makeLikesCoordinator(rootViewController: BaseViewController,
                             delegate: CoordinatorDelegate?,
                             factory: ControllerFactory,
                             usecaseProvider: UseCaseProvider) -> LikesCoordinator
}
