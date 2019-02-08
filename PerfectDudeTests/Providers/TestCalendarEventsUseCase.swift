//
//  TestCalendarEventsUseCase.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 31/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import XCTest
@testable import PerfectDude
@testable import Core
import RxSwift

final class TestCalendarEventsUseCase: Core.CalendarEventsUseCase {
    func save(event: CalendarEvent) -> Maybe<String> {
        return Maybe<String>.create { maybe in
            maybe(.success(""))
            return Disposables.create()
        }
    }
    
    func query(uuid: String, encrypted: Bool) -> Single<CalendarEvent> {
        return Single<CalendarEvent>.create { single in
            single(.success(CalendarEvent(eventType: .surprise,
                                          name: "",
                                          description: "",
                                          date: Date(),
                                          location: "Home",
                                          repeatCount: 0,
                                          repeatSize: .weeks)))
            return Disposables.create()
        }
    }
    
    func delete(event: CalendarEvent) -> Maybe<String> {
        return Maybe<String>.create { maybe in
            maybe(.completed)
            return Disposables.create()
        }
    }
    
    func queryAll() -> Observable<[CalendarEvent]> {
        return Observable.just([])
    }
}
