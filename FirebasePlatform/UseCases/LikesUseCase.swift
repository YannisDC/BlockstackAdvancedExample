//
//  LikesUseCase.swift
//  FirebasePlatform
//
//  Created by Yannis De Cleene on 21/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import Firebase

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
    
    func delete(like: Like) -> Maybe<String> {
        return Maybe.deferred {
            return Maybe<String>.create { maybe in
                maybe(.completed)
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
    }
    
    func queryAll() -> Observable<[Like]> {
        return Observable.just([])
    }
}
