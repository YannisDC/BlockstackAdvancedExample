//
//  HomeCoordinator.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeCoordinatorDelegate: class {
    /// Delegate method called if the app should be reset
    /// Can occur when a userlogin fails
    ///
    /// - Parameter coordinator: HomeCoordinator instance
    func reload(from coordinator: HomeCoordinator)
    
    /// Delegate method called if the app should reload the startup tasks
    ///
    /// - Parameter coordinator: HomeCoordinator instance
//    func reloadStartupTasks(from coordinator: HomeCoordinator)
}

final class HomeCoordinator: BaseCoordinator<HomeRoute> {
    
    
    
    fileprivate weak var rootViewController: BaseViewController!
    fileprivate weak var delegate: CoordinatorDelegate?
    fileprivate let disposeBag = DisposeBag()
    fileprivate let factory: ControllerFactory
    fileprivate let imagesTrigger = PublishSubject<UIImage?>()
    private var usecase = UseCaseProvider().blockstackUseCaseProvider.makeAuthUseCase()
    fileprivate let usecaseProvider: UseCaseProvider
    
    // MARK: Init
    
    init(rootViewController: BaseViewController,
         delegate: CoordinatorDelegate?,
         factory: ControllerFactory,
         usecaseProvider: UseCaseProvider) {
        self.rootViewController = rootViewController
        self.delegate = delegate
        self.factory = factory
        self.usecaseProvider = usecaseProvider
    }
    
    // MARK: Coordinator
    
    override func start() {
        super.start()
        coordinate(to: .home)
    }
    
    override func coordinate(to route: HomeRoute) {
        DispatchQueue.main.async {
            switch route {
            case .home:
                self.toHome()
            case .nextScreen:
                self.toNextScreen()
            case .signedIn:
                self.toSignedIn()
            case .signOut:
                self.signOut()
            }
        }
    }
}

// MARK: - SetupCoordinatorDelegate

extension HomeCoordinator: CoordinatorDelegate {
    func didFinish(coordinator: AnyCoordinator) {
        removeDependency(coordinator)
        
        rootViewController.contentViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Navigation

private extension HomeCoordinator {
    func toHome() {
        let homeViewController = factory.makeHomeViewController(coordinator: self,
                                                                imagesTrigger: imagesTrigger)
        rootViewController.setContentViewController(homeViewController)
    }
    
    func toNextScreen() {}
    
    func toSignedIn() {
        let goalCoordinator = GoalCoordinator(rootViewController: rootViewController,
                                              delegate: self)
        addDependency(goalCoordinator)
        goalCoordinator.start()
    }
    
    func signOut() {
        usecase.signUserOut()
        delegate?.didFinish(coordinator: self)
        DispatchQueue.main.async {
            AppDelegate.instance().reloadApp()
        }
    }
}

