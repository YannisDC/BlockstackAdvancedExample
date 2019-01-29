//
//  NetworkProvider.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 28/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import Blockstack

extension Like: Cachable {}

protocol Identifiable {
    var uuid: String { get set }
}

protocol Cryptable {
    var encrypted: Bool { get set }
}

protocol Cachable: Codable, Identifiable {}

protocol BlockstackProvidable: Cachable, Cryptable {}

protocol AbstractNetworkProvider {
    associatedtype T: BlockstackProvidable
    
    func save(entity: T) -> Maybe<String>
    func query(uuid: String, encrypted: Bool) -> Single<T>
    func query(uuid: String, username: String) -> Single<T>
    func queryAll() -> Observable<[T]>
    func queryAll(username: String) -> Observable<[T]>
    func delete(entity: T) -> Maybe<String>
}

final class NetworkProvider<T: BlockstackProvidable>: AbstractNetworkProvider {
    
    private let network: Network<T>
    private let cache: Cache<T>
    private let path: String = "\(T.self)"
    private let indexEncryption: Bool = false
    
    init(configuration: Blockstack.Configuration) {
        network = Network<T>(configuration: configuration)
        cache = Cache<T>(path: "\(T.self)")
    }
    
    func save(entity: T) -> Maybe<String> {
        return self.cache.save(object: entity)
            .andThen(network.loadIndex(path: path, decrypt: indexEncryption).flatMapMaybe({ (indexes) -> Maybe<String> in
                var newIndexes = indexes
                newIndexes.push(entity.uuid, encrypted: entity.encrypted)
                
                return self.network.save(path: "\(self.path)/\(entity.uuid)",
                    entity: entity,
                    encrypt: entity.encrypted)
                    .flatMap({ (_) -> Maybe<String> in
                        return self.network.saveIndex(path: self.path, index: newIndexes, encrypt: self.indexEncryption)
                    })
            }))
    }
    
    func query(uuid: String, encrypted: Bool) -> Single<T> {
        return network.load(path: "\(path)/\(uuid)", decrypt: encrypted)
    }
    
    func query(uuid: String, username: String) -> Single<T> {
        return network.load(path: "\(path)/\(uuid)", username: username)
    }
    
    func queryAll() -> Observable<[T]> {
        let fetchEntities = cache.fetchObjects().asObservable()
        
        let stored = network.loadIndex(path: path, decrypt: indexEncryption)
            .asObservable()
            .map({ (indexes) -> [Observable<T>] in
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
                    .map(to: [T].self)
                    .concat(Observable.just($0))
        }
        
        return fetchEntities.concat(stored)
    }
    
    func delete(entity: T) -> Maybe<String> {
        return self.cache.delete(object: entity)
            .andThen(network.loadIndex(path: path, decrypt: indexEncryption).flatMapMaybe({ (indexes) -> Maybe<String> in
                var newIndexes = indexes
                newIndexes.pop(entity.uuid)
                return self.network.delete(path: "\(self.path)/\(entity.uuid)").flatMap({ (filepath) -> Maybe<String> in
                    return self.network.saveIndex(path: self.path, index: newIndexes, encrypt: self.indexEncryption)
                })
            }))
    }
    
    // TODO: Add multiplayer query and queryAll using the network.loadIndex(path: String, username: String)
    func queryAll(username: String) -> Observable<[T]> {
        
        let fetchEntities = cache.fetchObjects().asObservable()
        
        let stored = network.loadIndex(path: path, username: username)
            .asObservable()
            .map({ (indexes) -> [Observable<T>] in
                return indexes.ids.compactMap({ fileIndex in
                    guard !fileIndex.encrypted else { return nil }
                    return self.query(uuid: fileIndex.id, encrypted: fileIndex.encrypted)
                        .asObservable()
                })
            })
            .flatMap(Observable.combineLatest)
            .share(replay: 1, scope: .forever)
            .flatMap {
                return self.cache.save(objects: $0)
                    .asObservable()
                    .map(to: [T].self)
                    .concat(Observable.just($0))
        }
        
        return fetchEntities.concat(stored)
        
        
//        return network.loadIndex(path: path, username: username)
//            .asObservable()
//            .map({ (indexes) -> [Observable<T>] in
//                return indexes.ids.compactMap({ fileIndex in
//                    guard !fileIndex.encrypted else { return nil }
//                    return self.query(uuid: fileIndex.id, encrypted: fileIndex.encrypted)
//                        .asObservable()
//                })
//            })
//            .flatMap(Observable.combineLatest)
    }
}

struct MapFromNever: Error {}
extension ObservableType where E == Never {
    func map<T>(to: T.Type) -> Observable<T> {
        return self.flatMap { _ in
            return Observable<T>.error(MapFromNever())
        }
    }
}
