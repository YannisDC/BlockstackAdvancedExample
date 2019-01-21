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

        let createCalendarEvent = input.createCalendarEventTrigger.do(onNext: {
            self.coordinator?.coordinate(to: .create)
        })
        
        return Output(title: title,
                      createCalendarEvent: createCalendarEvent)
    }
}

// MARK: - ViewModel

extension CalendarEventsViewModel {
    struct Input {
        let createCalendarEventTrigger: Driver<Void>
    }

    struct Output {
        let title: Driver<String>
        let createCalendarEvent: Driver<Void>
    }
}
