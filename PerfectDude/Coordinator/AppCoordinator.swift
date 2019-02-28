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
    fileprivate let disposeBag = DisposeBag()
    fileprivate weak var delegate: AppCoordinatorDelegate?
    fileprivate let coordinatorFactory: CoordinatorFactory
    fileprivate let factory: ControllerFactory
    fileprivate let useCaseProvider: Core.UseCaseProvider
    private let auth: AuthUseCase!
    fileprivate lazy var navigationController = NavigationController()
    
    // MARK: - Init
    
    init(rootViewController: BaseViewController,
         delegate: AppCoordinatorDelegate?,
         coordinatorFactory: CoordinatorFactory,
         factory: ControllerFactory,
         useCaseProvider: Core.UseCaseProvider) {
        self.rootViewController = rootViewController
        self.delegate = delegate
        self.coordinatorFactory = coordinatorFactory
        self.factory = factory
        self.useCaseProvider = useCaseProvider
        self.auth = useCaseProvider.makeAuthUseCase()
    }
    
    // MARK: - Start
    
    override func start(with option: DeepLinkOption?) {
        guard UserDefaults.standard.bool(forKey: "isPreOnboarded") else {
            coordinate(to: .preOnboarding)
            return
        }
        
        let deepLink = option
        if let deepLink = deepLink, !isActivated.value {
            isActivated.asObservable()
                .observeOn(MainScheduler.instance) // important to keep it on this thread
                .subscribe(onNext: { [weak self] isStarted in
                    guard isStarted else { return }
                    self?.start(with: deepLink)
                })
                .disposed(by: disposeBag)
            return
        }

        if auth.isUserSignedIn() {
            if let deepLink = deepLink {
                childCoordinators.forEach { $0.start(with: deepLink) }
                return
            }
            coordinate(to: .home)
        } else {
            coordinate(to: .authentication)
        }
    }
    
    override func coordinate(to route: AppRoute) {
        DispatchQueue.main.async {
            switch route {
            case .preOnboarding:
                self.toPreOnboarding()
            case .home:
                self.toHome()
            case .authentication:
                self.toAuthentication()
            }
        }
    }
    
    // MARK: - Public
    
    func reset() {
        removeAllDependencies()
        rootViewController.setContentViewController(nil)
        start()
    }
}

// MARK: - Private

private extension AppCoordinator {
    
    func toPreOnboarding() {
        let preOnboardingCoordinator = coordinatorFactory
            .makePreOnboardingCoordinator(rootViewController: rootViewController,
                                          delegate: self,
                                          factory: factory,
                                          useCaseProvider: self.useCaseProvider)
        addDependency(preOnboardingCoordinator)
        preOnboardingCoordinator.start()
    }
    
    func toHome() {
        let homeCoordinator = coordinatorFactory.makeHomeCoordinator(rootViewController: rootViewController,
                                                                     delegate: self,
                                                                     factory: factory,
                                                                     useCaseProvider: self.useCaseProvider)
        addDependency(homeCoordinator)
        homeCoordinator.start()
    }
    
    func toAuthentication() {
        let authViewController = factory.makeAuthenticationViewController(coordinator: self,
                                                                          useCaseProvider: self.useCaseProvider)
        rootViewController.setContentViewController(authViewController)
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
        
        if coordinator is HomeCoordinator {
            auth.signUserOut()
            coordinate(to: .authentication)
        }
        
        if coordinator is PreOnboardingCoordinator {
            UserDefaults.standard.set(true, forKey: "isPreOnboarded")
            coordinate(to: .home)
        }
        
        removeDependency(coordinator)
    }
}
