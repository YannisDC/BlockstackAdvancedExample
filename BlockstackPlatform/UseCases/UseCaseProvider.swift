//
//  UseCaseProvider.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 15/11/2018.
//  Copyright © 2018 sergdort. All rights reserved.
//

import Foundation
import Core
import Blockstack

public final class UseCaseProvider: Core.UseCaseProvider {
    
    private let configuration: Blockstack.Configuration

    public init() {
        self.configuration = Blockstack
            .Configuration(redirectURI: "https://youthful-spence-bbda8a.netlify.com/redirect.html",
                           appDomain: URL(string: "https://youthful-spence-bbda8a.netlify.com")!,
                           scopes: ["store_write", "publish_data"])
    }
    
    public func makeAuthUseCase() -> Core.AuthUseCase {
        let authentication = Authentication(configuration: configuration)
        return AuthUseCase(authentication: authentication)
    }
    
    public func makeInitUseCase() -> Core.InitUseCase {
        let network = Network<Index>(configuration: configuration)
        return InitUseCase(network: network)
    }
    
    public func makeLikesUseCase() -> Core.LikesUseCase {
        let network = NetworkFactory(configuration: configuration).makeLikeNetwork()
        return LikesUseCase(network: network)
    }
    
    public func makeCalendarEventsUseCase() -> Core.CalendarEventsUseCase {
        let network = NetworkFactory(configuration: configuration).makeCalendarEventNetwork()
        return CalendarEventsUseCase(network: network)
    }
    
}
