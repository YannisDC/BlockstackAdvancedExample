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
    let description: String
    
    init (with event: CalendarEvent) {
        self.event = event
        self.description = event.name ?? ""
        guard let date = event.date else {
            self.dateText = ""
            self.date = nil
            return
        }
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd"
        self.dateText = dateFormatterPrint.string(from: date)
        self.date = date
    }
}
