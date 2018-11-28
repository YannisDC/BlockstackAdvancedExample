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

extension Like: BlockstackProvidable {}

class NetworkFactory {
    
    private let configuration: Blockstack.Configuration
    
    public init() {
        self.configuration = Blockstack
            .Configuration(redirectURI: "https://pedantic-mahavira-f15d04.netlify.com/redirect.html",
                           appDomain: URL(string: "https://pedantic-mahavira-f15d04.netlify.com")!,
                           scopes: ["store_write", "publish_data"])
    }
    
    func makeLikeNetwork() -> NetworkProvider<Like>{
        return NetworkProvider<Like>(configuration: configuration)
    }
    
}
