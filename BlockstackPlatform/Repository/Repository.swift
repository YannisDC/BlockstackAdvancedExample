//
//  Repository.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 15/11/2018.
//  Copyright © 2018 sergdort. All rights reserved.
//

import Foundation
import Blockstack
import Core
import RxSwift

protocol AbstractRepository {
    associatedtype T: Codable
    func save(path: String, entity: T, encrypt: Bool) -> Maybe<String>
    func load(path: String, decrypt: Bool) -> Single<T>
    func delete(path: String) -> Maybe<String>
    
    func saveIndex(path: String, index: Index, encrypt: Bool) -> Maybe<String>
    func loadIndex(path: String, decrypt: Bool) -> Single<Index>
}

final class Repository<T: Codable>: AbstractRepository {
    private let configuration: Blockstack.Configuration
    private let scheduler: OperationQueueScheduler
    
    private let blockstack = Blockstack.shared
    
    init(configuration: Blockstack.Configuration) {
        self.configuration = configuration
        self.scheduler = OperationQueueScheduler(operationQueue: OperationQueue.init())
        //        print("File 📁 url: \(RLMRealmPathForFile("default.realm"))")
    }
    
    func save(path: String, entity: T, encrypt: Bool) -> Maybe<String> {
        do {
            let object = try JSONEncoder().encode(entity)
            return Maybe.deferred {
                return self.blockstack.rx.save(path: path, bytes: object.bytes, encrypt: encrypt)
                }.subscribeOn(scheduler)
        } catch{
            return Maybe.empty()
        }
    }
    
    func load(path: String, decrypt: Bool) -> Single<T> {
        return Single.deferred {
            return self.blockstack.rx.load(path: path, decrypt: decrypt).map { (response) -> T in
                guard let data = response as? Array<UInt8> else { throw CoreError.technical }
                return try JSONDecoder().decode(T.self, from: Data(bytes: data))
            }
            }.subscribeOn(scheduler)
    }
    
    func delete(path: String) -> Maybe<String> {
        return Maybe.deferred {
            return self.blockstack.rx.save(path: path, text: "")
            }.subscribeOn(scheduler)
    }
    
    func saveIndex(path: String, index: Index, encrypt: Bool) -> Maybe<String> {
        do {
            let object = try JSONEncoder().encode(index)
            return Maybe.deferred {
                return self.blockstack.rx.save(path: path, bytes: object.bytes, encrypt: encrypt)
                }.subscribeOn(scheduler)
        } catch{
            return Maybe.empty()
        }
    }
    
    func loadIndex(path: String, decrypt: Bool) -> Single<Index> {
        return Single.deferred {
            return self.blockstack.rx.load(path: path, decrypt: decrypt).map { (response) -> Index in
                guard let data = response as? Array<UInt8> else {
                    throw CoreError.technical
                }
                return try JSONDecoder().decode(Index.self, from: Data(bytes: data))
            }
            }.subscribeOn(scheduler)
    }
}
