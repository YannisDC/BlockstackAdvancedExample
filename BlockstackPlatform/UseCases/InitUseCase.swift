//
//  InitUseCase.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 19/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class InitUseCase<Repository>: Core.InitUseCase where Repository: AbstractRepository,
Repository.T == Index {
    
    private let repository: Repository
    private let likesPath: String = "likes"
    private let encryption: Bool = false
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func initLikeIndexes() -> Maybe<String> {
        return repository.saveIndex(path: likesPath, index: Index(ids: [], date: Date().timeIntervalSince1970), encrypt: false)
    }
}
