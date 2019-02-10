//
//  NetworkFactory.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 28/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import Blockstack

extension Core.Profile: BlockstackProvidable {}
extension Like: BlockstackProvidable {}
extension CalendarEvent: BlockstackProvidable {}

class NetworkFactory {
    
    private let configuration: Blockstack.Configuration
    
    init(configuration: Blockstack.Configuration) {
        self.configuration = configuration
    }
    
    func makeProfileNetwork() -> ProfileNetwork{
        return ProfileNetwork(configuration: configuration)
    }
    
    func makeLikeNetwork() -> NetworkProvider<Like>{
        return NetworkProvider<Like>(configuration: configuration)
    }
    
    func makeCalendarEventNetwork() -> NetworkProvider<CalendarEvent>{
        return NetworkProvider<CalendarEvent>(configuration: configuration)
    }
    
}
