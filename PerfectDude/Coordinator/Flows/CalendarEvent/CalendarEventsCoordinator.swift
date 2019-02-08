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
            case .events:
                self.toEvents()
            case .create:
                self.createCalendarEvent()
            case .edit(let event):
                self.editCalendarEvent(event: event)
            }
        }
    }
}

// MARK: - Private

private extension CalendarEventsCoordinator {
    func toOverview() {
        let calendarEventsViewController = factory.makeCalendarEventsViewController(coordinator: self, usecaseProvider: self.useCaseProvider)
        navigationController.setViewControllers([calendarEventsViewController], animated: false)
    }
    
    func toEvents() {
        navigationController.topViewController?.dismiss(animated: true, completion: nil)
    }
    
    func createCalendarEvent() {
        let createCalendarEventsViewController = factory.makeCreateCalendarEventViewController(coordinator: self, usecaseProvider: self.useCaseProvider)
        navigationController.pushViewController(createCalendarEventsViewController, animated: true)
    }
    
    func editCalendarEvent(event: CalendarEvent) {
        let editCalendarEventViewController = factory.makeEditCalendarEventViewController(coordinator: self,
                                                                                          usecaseProvider: self.useCaseProvider,
                                                                                          event: event)
        navigationController.pushViewController(editCalendarEventViewController, animated: true)
    }
}

// MARK: - CoordinatorDelegate

extension CalendarEventsCoordinator: CoordinatorDelegate {
    func didFinish(coordinator: AnyCoordinator) {
        removeDependency(coordinator)
    }
}
