//
//  ParentCoordinator.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation

class ParentCoordinator: NSObject, AnyCoordinator {
    
    func start() {
        start(with: nil)
    }
    
    func start(with option: DeepLinkOption?) {}
    
    fileprivate(set) var childCoordinators: [AnyCoordinator] = []
    
    func addDependency(_ coordinator: AnyCoordinator) {
        for element in childCoordinators where element === coordinator {
            // Don't store it twice
            return
        }
        
        childCoordinators.append(coordinator)
    }
    
    func removeAllDependencies() {
        childCoordinators.removeAll()
    }
    
    func removeDependency(_ coordinator: AnyCoordinator?) {
        guard childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
    
    /// Gets a childcoordinator of a given type if present otherwise nil
    func getChildCoordinator<T>(type: T.Type) -> T? {
        return childCoordinators.first(where: { $0 is T }) as? T
    }
    
}
