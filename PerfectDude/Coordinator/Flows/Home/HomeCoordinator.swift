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
    fileprivate let useCaseProvider: Core.UseCaseProvider
    private let auth: AuthUseCase!
    fileprivate let navigationController: NavigationController!
    
    // MARK: - Init
    
    init(rootViewController: BaseViewController,
         delegate: CoordinatorDelegate?,
         factory: ControllerFactory,
         useCaseProvider: Core.UseCaseProvider) {
        self.rootViewController = rootViewController
        self.delegate = delegate
        self.factory = factory
        self.useCaseProvider = useCaseProvider
        self.auth = useCaseProvider.makeAuthUseCase()
        self.navigationController = NavigationController()
    }
    
    // MARK: - Coordinator
    
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
                                                                useCaseProvider: useCaseProvider)
        homeViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        
        //        homeViewController.tabBarItem = UITabBarItem(title: "Settings",
        //                                                     image: UIImage(named: "blockstack_semi_filled"),
        //                                                     selectedImage: nil)
        
        let homeNavigationController = NavigationController()
        homeNavigationController.setViewControllers([homeViewController], animated: false)
        
        let calendarEventsCoordinator = CalendarEventsCoordinator(rootViewController: rootViewController,
                                                                  delegate: self,
                                                                  useCaseProvider: useCaseProvider,
                                                                  factory: factory)
        calendarEventsCoordinator.navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        
        let likesCoordinator = LikesCoordinator(rootViewController: rootViewController,
                                                delegate: self,
                                                factory: factory,
                                                useCaseProvider: useCaseProvider)
        likesCoordinator.navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            calendarEventsCoordinator.navigationController,
            likesCoordinator.navigationController,
            homeNavigationController
        ]
        rootViewController.setContentViewController(tabBarController)
        
        addDependency(calendarEventsCoordinator)
        calendarEventsCoordinator.start()
        
        addDependency(likesCoordinator)
        likesCoordinator.start()
    }
    
    func signOut() {
        auth.signUserOut()
        delegate?.didFinish(coordinator: self)
        DispatchQueue.main.async {
            AppDelegate.instance().reloadApp()
        }
    }
}

