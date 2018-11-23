//
//  HomeFactory.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 01/11/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeFactory {
    /// Creates a HomeViewController
    ///
    /// - Parameter coordinator: BaseCoordinator<HomeRouter> instance
    /// - Returns: HomeViewController instance
    func makeHomeViewController(coordinator: BaseCoordinator<HomeRoute>,
                                imagesTrigger: PublishSubject<UIImage?>) -> HomeViewController
}


