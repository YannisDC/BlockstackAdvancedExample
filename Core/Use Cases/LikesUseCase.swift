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
    
    func create(like: Like) -> Single<String?>
    func update(like: Like) -> Observable<Void>
    func query(uuid: String) -> Single<Like>
    func delete(like: Like) -> Single<String?>
    func queryAll() -> Observable<[Like]>
    
}
