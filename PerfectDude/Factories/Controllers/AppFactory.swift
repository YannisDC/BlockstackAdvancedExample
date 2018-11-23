//
//  AppFactory.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 01/11/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation

protocol AppFactory {
    /// Creates a AuthenticationViewController
    ///
    /// - Parameter coordinator: BaseCoordinator<AppRoute> instance
    /// - Returns: AuthenticationViewController instance
    func makeAuthenticationViewController(coordinator: BaseCoordinator<AppRoute>) -> AuthenticationViewController
}
