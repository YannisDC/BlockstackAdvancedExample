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
    
    init(configuration: Blockstack.Configuration) {
        self.configuration = configuration
    }
    
    func makeLikeNetwork() -> NetworkProvider<Like>{
        return NetworkProvider<Like>(configuration: configuration)
    }
    
}
