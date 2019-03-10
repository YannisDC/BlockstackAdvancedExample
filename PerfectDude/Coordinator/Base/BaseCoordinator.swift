//
//  BaseCoordinator.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift

class BaseCoordinator<AnyRoute: Route>: ParentCoordinator, Coordinator {
    var isActivated = Variable<Bool>(false)
    
    typealias CoordinatorRoute = AnyRoute
    
    deinit {
        print("DISPOSED \(NSStringFromClass(type(of: self)))")
    }
    
    override func start() {
        start(with: nil)
    }
    
    override func start(with option: DeepLinkOption?) {
        defer {
            isActivated.value = true
        }
    }
    
    func coordinate(to route: AnyRoute) { }
}
