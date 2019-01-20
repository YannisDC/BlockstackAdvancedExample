//
//  EventsUseCase.swift
//  Core
//
//  Created by Yannis De Cleene on 11/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import RxSwift

public protocol CalendarEventsUseCase {
    
    func save(like: CalendarEvent) -> Maybe<String>
    func query(uuid: String, encrypted: Bool) -> Single<CalendarEvent>
    func delete(like: CalendarEvent) -> Maybe<String>
    func queryAll() -> Observable<[CalendarEvent]>
    
}
