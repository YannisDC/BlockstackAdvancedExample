//
//  EditCalendarEventViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 07/03/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa
import UserNotifications

final class EditCalendarEventViewModel: CalendarEventViewModel {
    
    private weak var coordinator: BaseCoordinator<CalendarEventsRoute>?
    private let calendarEventsUsecase: CalendarEventsUseCase!
    private let event: CalendarEvent!
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<CalendarEventsRoute>?,
         useCaseProvider: Core.UseCaseProvider,
         event: CalendarEvent) {
        self.coordinator = coordinator
        self.calendarEventsUsecase = useCaseProvider.makeCalendarEventsUseCase()
        self.event = event
    }
    
    func removeLocalNotification(event: CalendarEvent) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests { (requests) in
            requests.forEach({ (request) in
                print("Content: \(request.content) - Identifier: \(request.identifier)")
            })
        }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [event.uuid])
    }
    
    // MARK: Transform
    
    override func transform(input: Input) -> Output {
        let title = Driver.just("edit".localized())
        let errorTracker = ErrorTracker()
        
        let eventDescription = Driver.merge(input.calendarEventTitle,
                                            Driver.just(event.name?.capitalized ?? ""))
        
        let isEditing = input.editTrigger
            .scan(false) { isEditing, _ in
                return !isEditing
            }
            .startWith(false)
        
        let isUpdating = Driver<Bool>.just(true)
        
        let deleteEvent = input.deleteTrigger
            .withLatestFrom(Driver.just(self.event))
            .do(onNext: { (event) in
                UNUserNotificationCenter.current().requestAuthorization(options:
                    [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
                        self.removeLocalNotification(event: event)
                })
                
            })
            .flatMapLatest { event in
                return self.calendarEventsUsecase.delete(event: event)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .mapToVoid()
            }
        
        let dismiss = Driver.of(deleteEvent)
            .merge().do(onNext: {
                self.coordinator?.coordinate(to: .overview)
            })
        
        let date = Driver<CalendarEvent>
            .just(event)
            .map { (event) -> Date in
                return event.date ?? Date()
            }
        
        let calendarEvents = Driver<[[CustomStringConvertible]]>
            .just([[1, 2, 3, 4, 5, 6], ["weeks".localized(), "months".localized(), "years".localized()]])
        
        let editButtonTitle = isEditing
            .map { isEditing -> String in
                return isEditing == true ? "save".localized() : "edit".localized()
            }
        
        return Output(title: title,
                      editButtonTitle: editButtonTitle,
                      saveEnabled: Driver<Bool>.just(true),
                      isEditing: isEditing,
                      isUpdating: isUpdating,
                      calendarEvents: calendarEvents,
                      date: date,
                      eventDescription: eventDescription,
                      delete: deleteEvent,
                      dismiss: dismiss)
    }
}
