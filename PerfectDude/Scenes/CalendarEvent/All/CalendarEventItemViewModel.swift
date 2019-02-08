//
//  CalendarEventItemViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 02/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core

final class CalendarEventItemViewModel   {
    let event: CalendarEvent
    let date: Date?
    let dateText: String
    let monthText: String
    let description: String
    
    init (with event: CalendarEvent) {
        self.event = event
        self.description = event.name ?? ""
        guard let date = event.date else {
            self.dateText = ""
            self.monthText = ""
            self.date = nil
            return
        }
        self.date = date
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "d"
        self.dateText = dateFormatterPrint.string(from: date)
        dateFormatterPrint.dateFormat = "MMM"
        self.monthText = dateFormatterPrint.string(from: date)
    }
}