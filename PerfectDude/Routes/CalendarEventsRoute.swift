//
//  CalendarEventsRoute.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 18/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core

enum CalendarEventsRoute: Route {
    case overview
    case events
    case create
    case edit(_ event: CalendarEvent)
}
