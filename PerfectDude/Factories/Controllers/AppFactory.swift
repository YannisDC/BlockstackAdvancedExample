//
//  AppFactory.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 01/11/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import Core

protocol AppFactory {
    /// Creates a AuthenticationViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<AppRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    /// - Returns: AuthenticationViewController instance
    func makeAuthenticationViewController(coordinator: BaseCoordinator<AppRoute>,
                                          useCaseProvider: Core.UseCaseProvider) -> AuthenticationViewController
}
