//
//  EventsUseCase.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 11/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class CalendarEventsUseCase<NetworkProvider>: Core.CalendarEventsUseCase where NetworkProvider: AbstractNetworkProvider, NetworkProvider.T == CalendarEvent {
    
    private let network: NetworkProvider
    
    init(network: NetworkProvider) {
        self.network = network
    }
    
    // TODO: catchErrors
    func save(like: CalendarEvent) -> Maybe<String> {
        return network.save(entity: like)
    }
    
    func query(uuid: String, encrypted: Bool) -> Single<CalendarEvent> {
        return network.query(uuid: uuid, encrypted: encrypted)
    }
    
    func delete(like: CalendarEvent) -> Maybe<String> {
        return network.delete(entity: like)
    }
    
    func queryAll() -> Observable<[CalendarEvent]> {
        return network.queryAll()
    }
}
