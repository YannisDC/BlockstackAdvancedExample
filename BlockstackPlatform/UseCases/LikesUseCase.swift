//
//  PostsUseCase.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 15/11/2018.
//  Copyright © 2018 sergdort. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class LikesUseCase<Repository, Cache>: Core.LikesUseCase where Repository: AbstractRepository,
Repository.T == Like, Cache: AbstractCache, Cache.T == Like {
    
    private let repository: Repository
    private let cache: Cache
    private let path: String = "likes"
    private let encryption: Bool = false
    
    init(repository: Repository, cache: Cache) {
        self.repository = repository
        self.cache = cache
    }
    
    // TODO: catchErrors
    func create(like: Like) -> Single<String?> {
        return repository.loadIndex(path: path, decrypt: encryption).flatMap({ (indexes) -> Single<String?> in
            var newIndexes = indexes
            newIndexes.push(like.uuid) // Alert on duplicate uuid
            return self.repository.save(path: "\(self.path)/\(like.uuid)", entity: like, encrypt: self.encryption).flatMap({ (filepath) -> Single<String?> in
                return self.repository.saveIndex(path: self.path, index: newIndexes, encrypt: self.encryption)
            })
        })
    }
    
    func update(like: Like) -> Single<String?> {
        print(like)
        return repository.save(path: "\(path)/\(like.uuid)", entity: like, encrypt: encryption)
    }
    
    func query(uuid: String) -> Single<Like> {
        return repository.load(path: "\(path)/\(uuid)", decrypt: encryption)
    }
    
    func delete(like: Like) -> Single<String?> {
        return repository.loadIndex(path: path, decrypt: encryption).flatMap({ (indexes) -> Single<String?> in
            var newIndexes = indexes
            newIndexes.pop(like.uuid)
            return self.repository.delete(path: "\(self.path)/\(like.uuid)").flatMap({ (filepath) -> Single<String?> in
                return self.repository.saveIndex(path: self.path, index: newIndexes, encrypt: self.encryption)
            })
        })
    }
    
    func queryAll() -> Observable<[Like]> {
        return repository.loadIndex(path: path, decrypt: encryption)
            .asObservable()
            .map({ (indexes) -> [Observable<Like>] in
                return indexes.ids.map({ fileIndex in
                    self.query(uuid: fileIndex)
                        .asObservable()
                })
            })
            .flatMap(Observable.combineLatest)
            .share(replay: 1, scope: .forever)
    }
}
