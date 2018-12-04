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
    fileprivate let navigationController: NavigationController!
    
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
        self.navigationController = NavigationController()
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
                self.setTabs()
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
    func setTabs() {
        let homeViewController = factory.makeHomeViewController(coordinator: self,
                                                                imagesTrigger: imagesTrigger)
        homeViewController.tabBarItem = UITabBarItem(title: "Blockstack",
                                                     image: UIImage(named: "blockstack_semi_filled"),
                                                     selectedImage: nil)
        
        let testCoordinator = LikesCoordinator(rootViewController: rootViewController,
                                               delegate: self,
                                               factory: factory,
                                               usecaseProvider: usecaseProvider)
        testCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Blockstack",
                                                                       image: UIImage(named: "blockstack_filled"),
                                                                       selectedImage: nil)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            homeViewController,
            testCoordinator.navigationController
        ]
        rootViewController.setContentViewController(tabBarController)
        
        addDependency(testCoordinator)
        testCoordinator.start()
    }
    
    func signOut() {
        auth.signUserOut()
        delegate?.didFinish(coordinator: self)
        DispatchQueue.main.async {
            AppDelegate.instance().reloadApp()
        }
    }
}

