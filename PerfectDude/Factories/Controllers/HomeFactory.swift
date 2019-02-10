//
//  HomeFactory.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 01/11/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import Core
import RxSwift

protocol HomeFactory {
    
    /// Creates a HomeViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<HomeRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    /// - Returns: HomeViewController instance
    func makeHomeViewController(coordinator: BaseCoordinator<HomeRoute>,
                                useCaseProvider: Core.UseCaseProvider) -> HomeViewController
}
