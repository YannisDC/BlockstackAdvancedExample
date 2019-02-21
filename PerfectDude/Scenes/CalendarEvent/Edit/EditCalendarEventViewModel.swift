//
//  EditCalendarEventViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 05/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa
import UserNotifications

final class EditCalendarEventViewModel: ViewModel {

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

    func transform(input: EditCalendarEventViewModel.Input) -> EditCalendarEventViewModel.Output {
        let title = Driver.just("Edit".localized())
        let errorTracker = ErrorTracker()
        
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

        return Output(title: title,
                      delete: deleteEvent,
                      dismiss: dismiss)
    }
}

// MARK: - ViewModel

extension EditCalendarEventViewModel {
    struct Input {
        let deleteTrigger: Driver<Void>
    }

    struct Output {
        let title: Driver<String>
        let delete: Driver<Void>
        let dismiss: Driver<Void>
    }
}
