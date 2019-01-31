//
//  PostsUseCase.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 15/11/2018.
//  Copyright © 2018 sergdort. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class LikesUseCase<NetworkProvider>: Core.LikesUseCase where NetworkProvider: AbstractNetworkProvider, NetworkProvider.T == Like {
    
    private let network: NetworkProvider
    
    init(network: NetworkProvider) {
        self.network = network
    }
    
    // TODO: catchErrors
    func save(like: Like) -> Maybe<String> {
        return network.save(entity: like)
    }
    
    func query(uuid: String, encrypted: Bool) -> Single<Like> {
        return network.query(uuid: uuid, encrypted: encrypted)
    }
    
    func query(uuid: String, username: String) -> Single<Like> {
        return network.query(uuid: uuid, username: username)
    }
    
    func delete(like: Like) -> Maybe<String> {
        return network.delete(entity: like)
    }
    
    func queryAll() -> Observable<[Like]> {
        return network.queryAll()
    }
    
    func queryAll(username: String) -> Observable<[Like]> {
        return network.queryAll(username: username)
    }
}
