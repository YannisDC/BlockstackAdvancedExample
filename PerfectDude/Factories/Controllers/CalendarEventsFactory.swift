//
//  CalendarEventsFactory.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 18/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

protocol CalendarEventsFactory {
    /// Creates a CalendarEventsViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<CalendarEventsRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    /// - Returns: CalendarEventsViewController
    func makeCalendarEventsViewController(coordinator: BaseCoordinator<CalendarEventsRoute>,
                                          useCaseProvider: Core.UseCaseProvider) -> CalendarEventsViewController
    
    /// Creates a CreateCalendarEventViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<CalendarEventsRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    /// - Returns: CreateCalendarEventViewController
    func makeCreateCalendarEventViewController(coordinator: BaseCoordinator<CalendarEventsRoute>,
                                               useCaseProvider: Core.UseCaseProvider) -> CreateCalendarEventViewController
    
    /// Creates an EditCalendarEventViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<CalendarEventsRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    ///   - event: CalendarEvent instance
    /// - Returns: EditCalendarEventViewController
    func makeEditCalendarEventViewController(coordinator: BaseCoordinator<CalendarEventsRoute>,
                                             useCaseProvider: Core.UseCaseProvider,
                                             event: CalendarEvent) -> EditCalendarEventViewController
}
