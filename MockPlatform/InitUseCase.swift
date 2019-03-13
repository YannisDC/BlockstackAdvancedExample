//
//  InitUseCase.swift
//  MockPlatform
//
//  Created by Yannis De Cleene on 13/03/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

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
