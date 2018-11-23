//
//  BaseCoordinator.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation

class BaseCoordinator<AnyRoute: Route>: ParentCoordinator, Coordinator {
    var isActivated: Bool = false
    
    typealias CoordinatorRoute = AnyRoute
    
    deinit {
        print("DISPOSED \(NSStringFromClass(type(of: self)))")
    }
    
    override func start() {
        defer {
            isActivated = true
        }
    }
    
    func coordinate(to route: AnyRoute) { }
}
