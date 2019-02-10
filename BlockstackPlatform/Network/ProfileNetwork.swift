//
//  ProfileNetwork.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 09/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Blockstack
import Core
import RxSwift

final class ProfileNetwork {
    private let configuration: Blockstack.Configuration
    private let scheduler: OperationQueueScheduler
    
    private let blockstack = Blockstack.shared
    
    init(configuration: Blockstack.Configuration) {
        self.configuration = configuration
        self.scheduler = OperationQueueScheduler(operationQueue: OperationQueue.init())
        print("Blockstack configured on domain: \(configuration.appDomain)")
    }
    
    func save(path: String, profile: Core.Profile, encrypt: Bool) -> Completable {
        do {
            let object = try JSONEncoder().encode(profile)
            return Completable.deferred {
                return self.blockstack.rx.save(path: path, bytes: object.bytes, encrypt: encrypt)
            }.subscribeOn(scheduler)
        } catch{
            return Completable.never()
        }
    }
    
    func load(path: String, decrypt: Bool) -> Single<Core.Profile> {
        return Single.deferred {
            return self.blockstack.rx.load(path: path, decrypt: decrypt).map { (response) -> Core.Profile in
                if decrypt {
                    guard let data = response as? DecryptedValue,
                        let bytes = data.bytes
                        else { throw CoreError.technical }
                    return try JSONDecoder().decode(Core.Profile.self, from: Data(bytes: bytes))
                } else {
                    guard let data = response as? Array<UInt8>
                        else { throw CoreError.technical }
                    return try JSONDecoder().decode(Core.Profile.self, from: Data(bytes: data))
                }
            }
        }.subscribeOn(scheduler)
    }
}
