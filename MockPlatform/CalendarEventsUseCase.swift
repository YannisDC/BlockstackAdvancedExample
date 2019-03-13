//
//  CalendarEventsUseCase.swift
//  MockPlatform
//
//  Created by Yannis De Cleene on 13/03/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class CalendarEventsUseCase: Core.CalendarEventsUseCase {
    private let scheduler: OperationQueueScheduler
    
    public init() {
        self.scheduler = OperationQueueScheduler(operationQueue: OperationQueue.init())
    }
    
    func save(event: CalendarEvent) -> Maybe<String> {
        return Maybe.deferred {
            return Maybe<String>.create { maybe in
                maybe(.completed)
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
    }
    
    func query(uuid: String, encrypted: Bool) -> Single<CalendarEvent> {
        return Single.deferred {
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
        }.subscribeOn(scheduler)
    }
    
    func delete(event: CalendarEvent) -> Maybe<String> {
        return Maybe.deferred {
            return Maybe<String>.create { maybe in
                maybe(.completed)
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
    }
    
    func queryAll() -> Observable<[CalendarEvent]> {
        return Observable.just([])
    }
}
