//
//  PreOnboardingCoordinator.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 05/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class PreOnboardingCoordinator: BaseCoordinator<PreOnboardingRoute> {

    fileprivate weak var rootViewController: BaseViewController!
    fileprivate weak var delegate: CoordinatorDelegate?
    fileprivate let useCaseProvider: Core.UseCaseProvider
    fileprivate let disposeBag = DisposeBag()
    fileprivate let factory: PreOnboardingFactory

    // MARK: Init

    init(rootViewController: BaseViewController,
         delegate: CoordinatorDelegate?,
         useCaseProvider: Core.UseCaseProvider,
         factory: PreOnboardingFactory) {

        self.rootViewController = rootViewController
        self.delegate = delegate
        self.useCaseProvider = useCaseProvider
        self.factory = factory
    }

    // MARK: Coordinator

    override func start() {
        coordinate(to: .overview)
    }

    override func coordinate(to route: PreOnboardingRoute) {
        DispatchQueue.main.async {
            switch route {
            case .overview:
                self.toOverView()
            case .finished:
                self.delegate?.didFinish(coordinator: self)
            }
        }
    }
}

// MARK: - Private

private extension PreOnboardingCoordinator {
    // TODO: - Present ViewControllers
    func toOverView() {
        let preOnboardingSingleViewController = factory
            .makePreOnboardingSingleViewController(coordinator: self,
                                             useCaseProvider: self.useCaseProvider)
        rootViewController.present(preOnboardingSingleViewController, animated: false, completion: nil)
    }
}

// MARK: - CoordinatorDelegate

extension PreOnboardingCoordinator: CoordinatorDelegate {
    func didFinish(coordinator: AnyCoordinator) {
        removeDependency(coordinator)
    }
}
