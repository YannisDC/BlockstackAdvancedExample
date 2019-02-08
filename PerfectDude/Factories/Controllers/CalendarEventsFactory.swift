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
    ///   - usecaseProvider: Core.UseCaseProvider instance
    /// - Returns: CalendarEventsViewController
    func makeCalendarEventsViewController(coordinator: BaseCoordinator<CalendarEventsRoute>,
                                          usecaseProvider: Core.UseCaseProvider) -> CalendarEventsViewController
    
    /// Creates a CreateCalendarEventViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<CalendarEventsRoute> instance
    ///   - usecaseProvider: Core.UseCaseProvider instance
    /// - Returns: CreateCalendarEventViewController
    func makeCreateCalendarEventViewController(coordinator: BaseCoordinator<CalendarEventsRoute>,
                                               usecaseProvider: Core.UseCaseProvider) -> CreateCalendarEventViewController
    
    /// Creates a EditCalendarEventViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<CalendarEventsRoute> instance
    ///   - usecaseProvider: Core.UseCaseProvider instance
    ///   - event: CalendarEvent instance
    /// - Returns: EditCalendarEventViewController
    func makeEditCalendarEventViewController(coordinator: BaseCoordinator<CalendarEventsRoute>,
                                             usecaseProvider: Core.UseCaseProvider,
                                             event: CalendarEvent) -> EditCalendarEventViewController
}
