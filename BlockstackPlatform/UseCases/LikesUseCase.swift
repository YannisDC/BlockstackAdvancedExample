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

final class LikesUseCase<Network, Cache>: Core.LikesUseCase where Network: AbstractNetwork,
Network.T == Like, Cache: AbstractCache, Cache.T == Like {
    
    private let network: Network
    private let cache: Cache
    private let path: String = "likes"
    private let indexEncryption: Bool = false
    
    init(network: Network, cache: Cache) {
        self.network = network
        self.cache = cache
    }
    
    // TODO: catchErrors
    func save(like: Like) -> Maybe<String> {
        return network.loadIndex(path: path, decrypt: indexEncryption).flatMapMaybe({ (indexes) -> Maybe<String> in
            var newIndexes = indexes
            newIndexes.push(like.uuid, encrypted: like.encrypted)
            
            return self.network.save(path: "\(self.path)/\(like.uuid)",
                entity: like,
                encrypt: like.encrypted)
                .flatMap({ (filepath) -> Maybe<String> in
                    return self.network.saveIndex(path: self.path, index: newIndexes, encrypt: self.indexEncryption)
                })
        })
    }
    
    func query(uuid: String, encrypted: Bool) -> Single<Like> {
        return network.load(path: "\(path)/\(uuid)", decrypt: encrypted)
    }
    
    func delete(like: Like) -> Maybe<String> {
        return network.loadIndex(path: path, decrypt: indexEncryption).flatMapMaybe({ (indexes) -> Maybe<String> in
            var newIndexes = indexes
            newIndexes.pop(like.uuid)
            return self.network.delete(path: "\(self.path)/\(like.uuid)").flatMap({ (filepath) -> Maybe<String> in
                return self.network.saveIndex(path: self.path, index: newIndexes, encrypt: self.indexEncryption)
            })
        })
    }
    
    func queryAll() -> Observable<[Like]> {
        let fetchLikes = cache.fetchObjects().asObservable()
        
        let stored = network.loadIndex(path: path, decrypt: indexEncryption)
            .asObservable()
            .map({ (indexes) -> [Observable<Like>] in
                return indexes.ids.map({ fileIndex in
                    self.query(uuid: fileIndex.id, encrypted: fileIndex.encrypted)
                        .asObservable()
                })
            })
            .flatMap(Observable.combineLatest)
            .share(replay: 1, scope: .forever)
            .flatMap {
                return self.cache.save(objects: $0)
                    .asObservable()
                    .map(to: [Like].self)
                    .concat(Observable.just($0))
        }
        
        return fetchLikes.concat(stored)
    }
}
