//
//  InitUseCase.swift
//  FirebasePlatform
//
//  Created by Yannis De Cleene on 21/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import Firebase

final class InitUseCase: Core.InitUseCase {
    private let scheduler: OperationQueueScheduler
    
    public init() {
        self.scheduler = OperationQueueScheduler(operationQueue: OperationQueue.init())
    }
    
    func initPublishPublicKey() -> Maybe<String> {
        return Maybe<String>.create { maybe in
            maybe(.completed)
            return Disposables.create()
        }
    }
    
    func initLikeIndexes() -> Maybe<String> {
        return Maybe.deferred {
            return Maybe<String>.create { maybe in
                maybe(.completed)
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
    }
    
    func initCalendarEventIndexes() -> Maybe<String> {
        return Maybe.deferred {
            return Maybe<String>.create { maybe in
                maybe(.completed)
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
    }
}
