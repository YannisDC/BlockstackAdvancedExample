//
//  CalendarEventsCoordinator.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 18/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class CalendarEventsCoordinator: BaseCoordinator<CalendarEventsRoute> {

    fileprivate weak var rootViewController: BaseViewController!
    fileprivate weak var delegate: CoordinatorDelegate?
    fileprivate let useCaseProvider: Core.UseCaseProvider
    fileprivate let disposeBag = DisposeBag()
    fileprivate let factory: CalendarEventsFactory
    public let navigationController: NavigationController!

    // MARK: Init

    init(rootViewController: BaseViewController,
         delegate: CoordinatorDelegate?,
         useCaseProvider: Core.UseCaseProvider,
         factory: CalendarEventsFactory) {

        self.rootViewController = rootViewController
        self.delegate = delegate
        self.useCaseProvider = useCaseProvider
        self.factory = factory
        self.navigationController = NavigationController()
    }

    // MARK: Coordinator

    override func start() {
        coordinate(to: .overview)
    }

    override func coordinate(to route: CalendarEventsRoute) {
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

private extension CalendarEventsCoordinator {
    func toOverview() {
        
    }
}

// MARK: - CoordinatorDelegate

extension CalendarEventsCoordinator: CoordinatorDelegate {
    func didFinish(coordinator: AnyCoordinator) {
        removeDependency(coordinator)
    }
}
