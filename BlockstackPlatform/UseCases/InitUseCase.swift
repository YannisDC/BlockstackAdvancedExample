//
//  InitUseCase.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 19/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class InitUseCase<Network>: Core.InitUseCase where Network: AbstractNetwork,
Network.T == Index {
    
    private let network: Network
    private let likesPath: String = "\(Like.self)"
    private let encryption: Bool = false
    
    init(network: Network) {
        self.network = network
    }
    
    func initLikeIndexes() -> Maybe<String> {
        return network.saveIndex(path: likesPath, index: Index(ids: [], date: Date().timeIntervalSince1970), encrypt: false)
    }
}
