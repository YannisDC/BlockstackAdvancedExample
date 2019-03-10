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
        self.description = event.name?.capitalized ?? ""
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


extension CalendarEventItemViewModel: Comparable {
    
    static func == (lhs: CalendarEventItemViewModel, rhs: CalendarEventItemViewModel) -> Bool {
        return false
    }
    
    static func < (lhs: CalendarEventItemViewModel, rhs: CalendarEventItemViewModel) -> Bool {
        guard let lhsDate = lhs.date?.withoutYearComponent().compensateForToday(), let rhsDate = rhs.date?.withoutYearComponent().compensateForToday() else {
            return false
        }
        return lhsDate < rhsDate
    }
}

extension Date {
    func withoutYearComponent() -> Date {
        let components = Calendar.current.dateComponents([.day, .month, .hour], from: self)
        return Calendar.current.date(from: components) ?? self
    }
    
    func compensateForToday() -> Date {
        if self < Date().withoutYearComponent() {
            return Calendar.current.date(byAdding: .year, value: 1, to: self) ?? self
        } else {
            return self
        }
    }
}
