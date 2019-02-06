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
        UIApplication.shared.scheduleLocalNotification(notification)
    }

    // MARK: Transform

    func transform(input: CreateCalendarEventViewModel.Input) -> CreateCalendarEventViewModel.Output {
        let title = Driver.just("Create".localized())
        let activityIndicator = ActivityIndicator()
        
        let canSave = Driver.combineLatest(input.calendarEventTitle, activityIndicator.asDriver()) {
            return !$0.isEmpty && !$1
        }
        
        let eventInfo = Driver.combineLatest(input.calendarEventTitle, input.calendarEventDate)
        
        let save = input.saveTrigger.withLatestFrom(eventInfo)
            .map { (title, date) in
                UNUserNotificationCenter.current().requestAuthorization(options:
                    [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
                        self.setLocalNotification(title: title)
                })
                
                return CalendarEvent(eventType: CalendarEventType.surprise,
                                     name: title,
                                     description: "",
                                     date: date,
                                     location: "Home",
                                     repeatCount: 1,
                                     repeatSize: RepeatSize.weeks,
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

        return Output(title: title,
                      saveEnabled: canSave,
                      dismiss: dismiss)
    }
}

// MARK: - ViewModel

extension CreateCalendarEventViewModel {
    struct Input {
        let saveTrigger: Driver<Void>
        let calendarEventTitle: Driver<String>
        let calendarEventDate: Driver<Date>
    }

    struct Output {
        let title: Driver<String>
        let saveEnabled: Driver<Bool>
        let dismiss: Driver<Void>
    }
}
