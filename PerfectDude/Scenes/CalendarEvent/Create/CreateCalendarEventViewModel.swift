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

final class CreateCalendarEventViewModel: CalendarEventViewModel {

    private weak var coordinator: BaseCoordinator<CalendarEventsRoute>?
    private let calendarEventsUsecase: CalendarEventsUseCase!
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<CalendarEventsRoute>?,
         useCaseProvider: Core.UseCaseProvider) {
        self.coordinator = coordinator
        self.calendarEventsUsecase = useCaseProvider.makeCalendarEventsUseCase()
    }
    
    func setLocalNotification(event: CalendarEvent, repeatCount: Int, repeatSize: RepeatSize) {
        
//        let day = 60 * 60 * 24
//        var interval: Int?
//
//        switch repeatSize {
//        case .weeks:
//            interval = day * 7 * repeatCount
//        case .months:
//            interval = day * 31 * repeatCount
//        case .years:
//            interval = day * 365 * repeatCount
//        }
//        print(interval)
        
        let content = UNMutableNotificationContent()
        content.title = event.name ?? ""
        content.body = event.description ?? ""

        let dateComponents = Calendar.current.dateComponents([.hour, .day, .month, .year], from: event.date ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: event.uuid,
                                            content: content,
                                            trigger: trigger)

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }

    // MARK: Transform

    override func transform(input: Input) -> Output {
        let title = Driver.just("Create".localized())
        let activityIndicator = ActivityIndicator()
        
        let canSave = Driver.combineLatest(input.calendarEventTitle, activityIndicator.asDriver()) {
            return !$0.isEmpty && !$1
        }
        
        let isEditing = Driver<Bool>.just(true)
        let isUpdating = Driver<Bool>.just(false)
        
        let eventInfo = Driver.combineLatest(input.calendarEventTitle, input.calendarEventDate, input.selection.startWith([1, "weeks".localized()]))
        
        let save = input.editTrigger.withLatestFrom(eventInfo)
            .map { (title, date, frequency) in
                let event: CalendarEvent
                
                print(Calendar.current.getDatesForSpecialDayReminder(specialDate: Date()))
                
                guard frequency.count == 2,
                    let repeatCount = frequency[0] as? Int,
                    let repeatSize = RepeatSize(rawValue: frequency[1].description) else {
                        event = CalendarEvent(eventType: CalendarEventType.surprise,
                                             name: title,
                                             description: "",
                                             date: date,
                                             location: "Home",
                                             encrypted: false)
                        return event
                }
                
                event = CalendarEvent(eventType: CalendarEventType.surprise,
                                     name: title,
                                     description: "",
                                     date: date,
                                     location: "Home",
                                     repeatCount: repeatCount,
                                     repeatSize: repeatSize,
                                     encrypted: false)
                
                self.setLocalNotification(event: event, repeatCount: repeatCount, repeatSize: repeatSize)
                
                UNUserNotificationCenter.current().requestAuthorization(options:
                    [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
                        self.setLocalNotification(event: event, repeatCount: repeatCount, repeatSize: repeatSize)
                })
                
                return event
            }
            .flatMapLatest { [unowned self] in
                return self.calendarEventsUsecase.save(event: $0)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete().flatMap({ (_) -> Driver<Void> in
                        return Driver.just(())
                    })
            }
        
        let dismiss = Driver.of(save)
            .merge()
            .do(onNext: {
                self.coordinator?.coordinate(to: .overview)
            })
        
        let calendarEvents = Driver<[[CustomStringConvertible]]>.just([[1, 2, 3, 4, 5, 6], ["weeks".localized(), "months".localized(), "years".localized()]])
        
        let editButtonTitle = isEditing
            .map { isEditing -> String in
                return isEditing == true ? "save".localized() : "edit".localized()
            }

        return Output(title: title,
                      editButtonTitle: editButtonTitle,
                      saveEnabled: canSave,
                      isEditing: isEditing,
                      isUpdating: isUpdating,
                      calendarEvents: calendarEvents,
                      date: Driver<Date>.just(Date()),
                      eventDescription: input.calendarEventTitle,
                      delete: Driver<Void>.just(()),
                      dismiss: dismiss)
    }
}
