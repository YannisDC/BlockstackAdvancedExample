//
//  ProfileUseCase.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 09/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class ProfileUseCase: Core.ProfileUseCase  {
    
    private let network: ProfileNetwork
    
    private let path: String = "Profile"
    private let profileEncryption: Bool = true
    
    init(network: ProfileNetwork) {
        self.network = network
    }
    
    func getProfile() -> Single<Core.Profile> {
        return network.load(path: path, decrypt: profileEncryption)
    }
    
    func saveProfile(profile: Core.Profile) -> Completable {
        return network.save(path: path, profile: profile, encrypt: profileEncryption)
    }
}
