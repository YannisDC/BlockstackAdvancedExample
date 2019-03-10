//
//  CalendarEventViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 07/03/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa
import TagListView

class CalendarEventViewModel: ViewModel {
    
    func transform(input: Input) -> Output {
        fatalError("Implement me")
    }
    
    struct Input {
        let editTrigger: Driver<Void>
        let deleteTrigger: Driver<Void>
        let calendarEventTitle: Driver<String>
        let calendarEventDate: Driver<Date>
        let selection: Driver<[CustomStringConvertible]>
    }
    
    struct Output {
        let title: Driver<String>
        let editButtonTitle: Driver<String>
        let saveEnabled: Driver<Bool>
        let isEditing: Driver<Bool>
        let isUpdating: Driver<Bool>
        let calendarEvents: Driver<[[CustomStringConvertible]]>
        let date: Driver<Date>
        let eventDescription: Driver<String>
        let delete: Driver<Void>
        let dismiss: Driver<Void>
    }
}
