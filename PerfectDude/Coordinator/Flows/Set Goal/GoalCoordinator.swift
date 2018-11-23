//
//  GoalCoordinator.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 17/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift

protocol GoalCoordinatorDelegate: class {
    /// Delegate method called if the app should be reset
    /// Can occur when a userlogin fails
    ///
    /// - Parameter coordinator: GoalCoordinator instance
    func reload(from coordinator: GoalCoordinator)
    
    /// Delegate method called if the app should reload the startup tasks
    ///
    /// - Parameter coordinator: GoalCoordinator instance
    func reloadStartupTasks(from coordinator: GoalCoordinator)
}

final class GoalCoordinator: BaseCoordinator<GoalRoute> {
    
    fileprivate weak var rootViewController: BaseViewController!
    fileprivate weak var delegate: CoordinatorDelegate?
    fileprivate let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(rootViewController: BaseViewController,
         delegate: CoordinatorDelegate?) {
        self.rootViewController = rootViewController
        self.delegate = delegate
    }
    
    // MARK: Coordinator
    
    override func start() {
        super.start()
        coordinate(to: .targetWeight)
    }
    
    override func coordinate(to route: GoalRoute) {
        DispatchQueue.main.async {
            switch route {
            case .personalInformation:
                self.didFinish(coordinator: self)
            case .targetWeight:
                self.toTargetWeight()
            }
        }
    }
}

// MARK: - SetupCoordinatorDelegate

extension GoalCoordinator: CoordinatorDelegate {
    func didFinish(coordinator: AnyCoordinator) {
        removeDependency(coordinator)
        
        rootViewController.contentViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Navigation

private extension GoalCoordinator {
    func toTargetWeight() {
        let targetWeightViewController = TargetWeightViewController.loadFromNib()
        let targetWeightViewModel = TargetWeightViewModel(coordinator: self)
        
        targetWeightViewController.bindViewModel(to: targetWeightViewModel)
        rootViewController.setContentViewController(targetWeightViewController)
    }
}
