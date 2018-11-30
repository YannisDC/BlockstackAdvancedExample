//
//  HomeCoordinator.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class HomeCoordinator: BaseCoordinator<HomeRoute> {
    
    fileprivate weak var rootViewController: BaseViewController!
    fileprivate weak var delegate: CoordinatorDelegate?
    fileprivate let factory: ControllerFactory
    fileprivate let imagesTrigger = PublishSubject<UIImage?>()
    fileprivate let usecaseProvider: Core.UseCaseProvider
    private let auth: AuthUseCase!
    
    // MARK: Init
    
    init(rootViewController: BaseViewController,
         delegate: CoordinatorDelegate?,
         factory: ControllerFactory,
         usecaseProvider: Core.UseCaseProvider) {
        self.rootViewController = rootViewController
        self.delegate = delegate
        self.factory = factory
        self.usecaseProvider = usecaseProvider
        self.auth = usecaseProvider.makeAuthUseCase()
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
            case .likes:
                self.delegate?.didFinish(coordinator: self)
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
    
    func signOut() {
        auth.signUserOut()
        delegate?.didFinish(coordinator: self)
        DispatchQueue.main.async {
            AppDelegate.instance().reloadApp()
        }
    }
}

