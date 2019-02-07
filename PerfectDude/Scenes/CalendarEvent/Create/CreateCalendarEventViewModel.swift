//
//  CreateCalendarEventViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 21/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa
import UserNotifications

final class CreateCalendarEventViewModel: ViewModel {

    private weak var coordinator: BaseCoordinator<CalendarEventsRoute>?
    private let calendarEventsUsecase: CalendarEventsUseCase!
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<CalendarEventsRoute>?,
         usecaseProvider: Core.UseCaseProvider) {
        self.coordinator = coordinator
        self.calendarEventsUsecase = usecaseProvider.makeCalendarEventsUseCase()
    }
    
    func setLocalNotification(title: String) {
        let notification = UILocalNotification()
        notification.fireDate = Date(timeIntervalSinceNow: 5)
        notification.alertTitle = title
        notification.alertBody = "Comming up soon"
        DispatchQueue.main.async {
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }

    // MARK: Transform

    func transform(input: CreateCalendarEventViewModel.Input) -> CreateCalendarEventViewModel.Output {
        let title = Driver.just("Create".localized())
        let activityIndicator = ActivityIndicator()
        
        let canSave = Driver.combineLatest(input.calendarEventTitle, activityIndicator.asDriver()) {
            return !$0.isEmpty && !$1
        }
        
        let eventInfo = Driver.combineLatest(input.calendarEventTitle, input.calendarEventDate, input.selection)
        
        let save = input.saveTrigger.withLatestFrom(eventInfo)
            .map { (title, date, frequency) in
                UNUserNotificationCenter.current().requestAuthorization(options:
                    [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
                        self.setLocalNotification(title: title)
                })
                
                guard frequency.count == 2,
                    let repeatCount = frequency[0] as? Int,
                    let repeatSize = RepeatSize(rawValue: frequency[1].description) else {
                        return CalendarEvent(eventType: CalendarEventType.surprise,
                                             name: title,
                                             description: "",
                                             date: date,
                                             location: "Home",
                                             repeatCount: 1,
                                             repeatSize: RepeatSize.weeks,
                                             encrypted: false)
                }
                
                return CalendarEvent(eventType: CalendarEventType.surprise,
                                     name: title,
                                     description: "",
                                     date: date,
                                     location: "Home",
                                     repeatCount: repeatCount,
                                     repeatSize: repeatSize,
                                     encrypted: false)
                
            }
            .flatMapLatest { [unowned self] in
                return self.calendarEventsUsecase.save(event: $0)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete().flatMap({ (_) -> Driver<Void> in
                        return Driver.just(())
                    })
        }
        
        let dismiss = Driver.of(save)
            .merge().do(onNext: {
                self.coordinator?.coordinate(to: .overview)
            })
        
        let calendarEvents = Driver<[[CustomStringConvertible]]>.just([[1, 2, 3, 4, 5, 6], ["week(s)", "month(s)", "year(s)"]])
        

        return Output(title: title,
                      saveEnabled: canSave,
                      dismiss: dismiss,
                      calendarEvents: calendarEvents)
    }
}

// MARK: - ViewModel

extension CreateCalendarEventViewModel {
    struct Input {
        let saveTrigger: Driver<Void>
        let calendarEventTitle: Driver<String>
        let calendarEventDate: Driver<Date>
        let selection: Driver<[CustomStringConvertible]>
    }

    struct Output {
        let title: Driver<String>
        let saveEnabled: Driver<Bool>
        let dismiss: Driver<Void>
        let calendarEvents: Driver<[[CustomStringConvertible]]>
    }
}
