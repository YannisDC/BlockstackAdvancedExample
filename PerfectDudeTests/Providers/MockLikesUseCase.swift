//
//  MockLikesUseCase.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 31/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import XCTest
@testable import PerfectDude
@testable import Core
import RxSwift

final class MockLikesUseCase: Core.LikesUseCase {
    func save(like: Like) -> Maybe<String> {
        return Maybe<String>.create { maybe in
            maybe(.success(""))
            return Disposables.create()
        }
    }
    
    func query(uuid: String, encrypted: Bool) -> Single<Like> {
        return Single<Like>.create { single in
            single(.success(Like(description: "",
                                 image: nil,
                                 tags: [])))
            return Disposables.create()
        }
    }
    
    func query(uuid: String, username: String) -> Single<Like> {
        return Single<Like>.create { single in
            single(.success(Like(description: "",
                                 image: nil,
                                 tags: [])))
            return Disposables.create()
        }
    }
    
    func delete(like: Like) -> Maybe<String> {
        return Maybe<String>.create { maybe in
            maybe(.completed)
            return Disposables.create()
        }
    }
    
    func queryAll() -> Observable<[Like]> {
        return Maybe<[Like]>.create { maybe in
            maybe(.success([Like(description: "",
                                 image: nil,
                                 tags: [])]))
            return Disposables.create()
        }.asObservable()
    }
    
    func queryAll(username: String) -> Observable<[Like]> {
        return Maybe<[Like]>.create { maybe in
            maybe(.success([Like(description: "",
                                 image: nil,
                                 tags: [])]))
            return Disposables.create()
        }.asObservable()
    }
}
