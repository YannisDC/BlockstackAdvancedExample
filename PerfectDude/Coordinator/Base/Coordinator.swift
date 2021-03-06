//
//  Coordinator.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift

protocol CoordinatorDelegate: class {
    /// Delegate method called if the coordinator is finished completely
    ///
    /// - Parameter coordinator: Coordinator instance
    func didFinish(coordinator: AnyCoordinator)
}

// Alternative for type erasure
protocol AnyCoordinator: class {
    /// Start method for the coordinator
    func start()
    
    /// Start method for a coordinator
    ///
    /// - Parameter option: DeepLinkOption instance
    func start(with option: DeepLinkOption?)
}

protocol Coordinator: AnyCoordinator {
    associatedtype CoordinatorRoute: Route
    
    /// The methode called to define all routes
    ///
    /// - Parameter route: CoordinatorRoute instance
    func coordinate(to route: CoordinatorRoute)
    
    var isActivated: Variable<Bool> { get set }
}
