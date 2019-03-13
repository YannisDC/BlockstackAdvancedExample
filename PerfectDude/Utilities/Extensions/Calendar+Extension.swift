//
//  Calendar+Extension.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 10/03/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation

extension Calendar {
//    func getDatesForNextYear() -> [Date] {
//        return [Date()]
//    }
    
    func getDatesForSpecialDayReminder(specialDate: Date) -> [Date] {
        
        // One month before
        guard let oneMonthInAdvance = self.date(byAdding: .month, value: -1, to: specialDate) else { return [] }
        // 2 weeks before
        guard let twoWeeksInAdvance = self.date(byAdding: .weekOfYear, value: -2, to: specialDate) else { return [] }
        // one week before
        guard let oneWeekInAdvance = self.date(byAdding: .weekOfYear, value: -1, to: specialDate) else { return [] }
        // 3 days before
        guard let threeDaysInAdvance = self.date(byAdding: .day, value: -3, to: specialDate) else { return [] }
        // 1 day before
        guard let oneDayInAdvance = self.date(byAdding: .day, value: -1, to: specialDate) else { return [] }
        
        let specialDateReminderDates = [oneMonthInAdvance,
                                        twoWeeksInAdvance,
                                        oneWeekInAdvance,
                                        threeDaysInAdvance,
                                        oneDayInAdvance]
        
        return specialDateReminderDates
    }
}
