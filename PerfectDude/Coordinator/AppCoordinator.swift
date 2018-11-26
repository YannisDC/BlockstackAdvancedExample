//
//  AppCoordinator.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift
import Core

protocol AppCoordinatorDelegate: class {
    /// Delegate method called if startupTasks should rerun
    ///
    /// - Parameter coordinator: AppCoordinator instance
    func reloadStartupTasks(coordinator: HomeCoordinator)
}

final class AppCoordinator: BaseCoordinator<AppRoute> {
    
    // Properties
    fileprivate let rootViewController: BaseViewController
    fileprivate weak var delegate: AppCoordinatorDelegate?
    fileprivate let coordinatorFactory: CoordinatorFactory
    fileprivate let factory: ControllerFactory
    fileprivate let usecaseProvider: Core.UseCaseProvider
    private let auth: AuthUseCase!
    fileprivate lazy var navigationController = NavigationController()
    
    // MARK: Init
    
    init(rootViewController: BaseViewController,
         delegate: AppCoordinatorDelegate?,
         coordinatorFactory: CoordinatorFactory,
         factory: ControllerFactory,
         usecaseProvider: Core.UseCaseProvider) {
        self.rootViewController = rootViewController
        self.delegate = delegate
        self.coordinatorFactory = coordinatorFactory
        self.factory = factory
        self.usecaseProvider = usecaseProvider
        self.auth = usecaseProvider.makeAuthUseCase()
    }
    
    // MARK: Start
    
    override func start() {
        defer {
            isActivated = true
        }
        
        if auth.isUserSignedIn() {
            coordinate(to: .home)
        } else {
            coordinate(to: .authentication)
        }
    }
    
    override func coordinate(to route: AppRoute) {
        DispatchQueue.main.async {
            switch route {
            case .home:
//                self.toHome()
                self.toLikes()
            case .authentication:
                self.toAuthentication()
            }
        }
    }
    
    // MARK: Public
    
    func reset() {
        removeAllDependencies()
        rootViewController.setContentViewController(nil)
        start()
    }
}

// MARK: - Private

private extension AppCoordinator {
    
    func toHome() {
        let homeCoordinator = coordinatorFactory.makeHomeCoordinator(rootViewController: rootViewController,
                                                                     delegate: self,
                                                                     factory: factory,
                                                                     usecaseProvider: self.usecaseProvider)
        addDependency(homeCoordinator)
        homeCoordinator.start()
    }
    
    func toAuthentication() {
        let authViewController = factory.makeAuthenticationViewController(coordinator: self,
                                                                          useCaseProvider: self.usecaseProvider)
        rootViewController.setContentViewController(authViewController)
    }
    
    func toLikes() {
        let likesCoordinator = coordinatorFactory.makeLikesCoordinator(rootViewController: rootViewController,
                                                                     delegate: self,
                                                                     factory: factory,
                                                                     usecaseProvider: self.usecaseProvider)
        addDependency(likesCoordinator)
        likesCoordinator.start()
    }
    
    func showError(error: Error, completion: @escaping (() -> Void)) {
        guard let contentController = rootViewController.contentViewController,
            let topController = UIApplication.topViewController(controller: contentController) else { return }
        topController.showAlert(error: error, completion: completion)
    }
}

// MARK: - OnboardingCoordinatorDelegate

extension AppCoordinator: CoordinatorDelegate {
    func didFinish(coordinator: AnyCoordinator) {
        removeDependency(coordinator)
        coordinate(to: .home)
    }
}
