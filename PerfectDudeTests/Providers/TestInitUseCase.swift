//
//  TestInitUseCase.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 31/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import XCTest
@testable import PerfectDude
@testable import Core
import RxSwift

final class TestInitUseCase: Core.InitUseCase {
    func initPublishPublicKey() -> Maybe<String> {
        return Maybe<String>.create { maybe in
            maybe(.success(""))
            return Disposables.create()
        }
    }
    
    func initLikeIndexes() -> Maybe<String> {
        return Maybe<String>.create { maybe in
            maybe(.success(""))
            return Disposables.create()
        }
    }
    
    func initCalendarEventIndexes() -> Maybe<String> {
        return Maybe<String>.create { maybe in
            maybe(.success(""))
            return Disposables.create()
        }
    }
}
