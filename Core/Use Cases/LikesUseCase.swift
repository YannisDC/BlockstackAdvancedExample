//
//  LikesUseCase.swift
//  Core
//
//  Created by Yannis De Cleene on 16/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import RxSwift

public protocol LikesUseCase {
    
    func create(like: Like) -> Maybe<String>
    func update(like: Like) -> Observable<Void>
    func query(uuid: String, encrypted: Bool) -> Single<Like>
    func delete(like: Like) -> Maybe<String>
    func queryAll() -> Observable<[Like]>
    
}
