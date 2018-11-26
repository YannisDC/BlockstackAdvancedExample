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
            .Configuration(redirectURI: "https://pedantic-mahavira-f15d04.netlify.com/redirect.html",
                           appDomain: URL(string: "https://pedantic-mahavira-f15d04.netlify.com")!,
                           scopes: ["store_write", "publish_data"])
    }
    
    public func makeLikesUseCase() -> Core.LikesUseCase {
        let repository = Repository<Like>(configuration: configuration)
        let cache = Cache<Like>(path: "likes")
        return LikesUseCase(repository: repository, cache: cache)
    }
    
    public func makeAuthUseCase() -> Core.AuthUseCase {
        let authentication = Authentication(configuration: configuration)
        return AuthUseCase(authentication: authentication)
    }
    
    public func makeInitUseCase() -> Core.InitUseCase {
        let repository = Repository<Index>(configuration: configuration)
        return InitUseCase(repository: repository)
    }
    
}
