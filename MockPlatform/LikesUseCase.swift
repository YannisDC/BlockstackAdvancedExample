//
//  LikesUseCase.swift
//  MockPlatform
//
//  Created by Yannis De Cleene on 13/03/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class LikesUseCase: Core.LikesUseCase {
    private let scheduler: OperationQueueScheduler
    
    public init() {
        self.scheduler = OperationQueueScheduler(operationQueue: OperationQueue.init())
    }
    
    func save(like: Like) -> Maybe<String> {
        return Maybe.deferred {
            return Maybe<String>.create { maybe in
                maybe(.completed)
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
    }
    
    func query(uuid: String, encrypted: Bool) -> Single<Like> {
        return Single.deferred {
            return Single<Like>.create { single in
                single(.success(Like(description: "",
                                     image: nil,
                                     tags: [])))
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
    }
    
    func query(uuid: String, username: String) -> Single<Like> {
        return Single.deferred {
            return Single<Like>.create { single in
                single(.success(Like(description: "Test",
                                     image: #imageLiteral(resourceName: "clouds"),
                                     tags: [])))
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
    }
    
    func delete(like: Like) -> Maybe<String> {
        return Maybe.deferred {
            return Maybe<String>.create { maybe in
                maybe(.completed)
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
    }
    
    func queryAll() -> Observable<[Like]> {
        
        let maybe = Maybe.deferred {
            return Maybe<[Like]>.create { maybe in
                let like = Like(description: "Test", image: #imageLiteral(resourceName: "clouds"), tags: [])
                maybe(.success([like]))
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
        
        return maybe.asObservable()
    }
    
    func queryAll(username: String) -> Observable<[Like]> {
        
        let maybe = Maybe.deferred {
            return Maybe<[Like]>.create { maybe in
                let like = Like(description: "", image: nil, tags: [])
                maybe(.success([like]))
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
        
        return maybe.asObservable()
    }
}
