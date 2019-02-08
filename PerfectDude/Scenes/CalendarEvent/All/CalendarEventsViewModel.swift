//
//  CalendarEventsViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 20/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa

final class CalendarEventsViewModel: ViewModel {

    private weak var coordinator: BaseCoordinator<CalendarEventsRoute>?
    private let calendarEventsUsecase: CalendarEventsUseCase!

    // MARK: Init

    init(coordinator: BaseCoordinator<CalendarEventsRoute>?,
         usecaseProvider: Core.UseCaseProvider) {
        self.coordinator = coordinator
        self.calendarEventsUsecase = usecaseProvider.makeCalendarEventsUseCase()
    }

    // MARK: Transform

    func transform(input: CalendarEventsViewModel.Input) -> CalendarEventsViewModel.Output {
        let title = Driver.just("Events".localized())
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let calendarEvents = input.trigger.flatMapLatest { _ in
            return self.calendarEventsUsecase.queryAll()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { $0.map { CalendarEventItemViewModel(with: $0) }.sorted(by: { $0.dateText < $1.dateText }) }
        }
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        let selectedCalendarEvent = input.selection
            .withLatestFrom(calendarEvents) { (indexPath, calendarEvents) -> CalendarEvent in
                return calendarEvents[indexPath.row].event
            }.do(onNext: { event in
                self.coordinator?.coordinate(to: .edit(event))
            })
        
        let createCalendarEvent = input.createCalendarEventTrigger.do(onNext: {
            self.coordinator?.coordinate(to: .create)
        })
        
        return Output(title: title,
                      fetching: fetching,
                      calendarEvents: calendarEvents,
                      createCalendarEvent: createCalendarEvent,
                      selectedCalendarEvent: selectedCalendarEvent,
                      error: errors)
    }
}

// MARK: - ViewModel

extension CalendarEventsViewModel {
    struct Input {
        let trigger: Driver<Void>
        let createCalendarEventTrigger: Driver<Void>
        let selection: Driver<IndexPath>
    }

    struct Output {
        let title: Driver<String>
        let fetching: Driver<Bool>
        let calendarEvents: Driver<[CalendarEventItemViewModel]>
        let createCalendarEvent: Driver<Void>
        let selectedCalendarEvent: Driver<CalendarEvent>
        let error: Driver<Error>
    }
}
