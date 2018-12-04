//
//  TestCoordinator.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 04/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class TestCoordinator: BaseCoordinator<TestRoute> {

    fileprivate weak var rootViewController: BaseViewController!
    fileprivate weak var delegate: CoordinatorDelegate?
    fileprivate let useCaseProvider: Core.UseCaseProvider
    fileprivate let disposeBag = DisposeBag()
    public let navigationController: NavigationController!

    // MARK: Init

    init(rootViewController: BaseViewController,
         delegate: CoordinatorDelegate?,
         useCaseProvider: Core.UseCaseProvider) {

        self.rootViewController = rootViewController
        self.delegate = delegate
        self.useCaseProvider = useCaseProvider
        self.navigationController = NavigationController()
    }

    // MARK: Coordinator

    override func start() {
        coordinate(to: .overview)
    }

    override func coordinate(to route: TestRoute) {
        DispatchQueue.main.async {
            switch route {
            case .overview:
                self.toOverview()
            default:
                break
            }
        }
    }
}

// MARK: - Private

private extension TestCoordinator {
    // TODO: - Present ViewControllers
    func toOverview() {
        let testVC = TestViewController.loadFromNib()
        let testVM = TestViewModel(coordinator: self)
        testVC.viewModel = testVM
        testVC.bindViewModel()
        navigationController.setViewControllers([testVC], animated: true)
    }
}

// MARK: - CoordinatorDelegate

extension TestCoordinator: CoordinatorDelegate {
    func didFinish(coordinator: AnyCoordinator) {
        removeDependency(coordinator)
    }
}
