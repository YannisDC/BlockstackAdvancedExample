//
//  AuthUseCase.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 16/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import Blockstack

final class AuthUseCase<Authentication>: Core.AuthUseCase where Authentication: AbstractAuthentication {
    
    private let authentication: Authentication
    
    init(authentication: Authentication) {
        self.authentication = authentication
    }

    func signIn() -> Single<Void> {
        return authentication.signIn()
    }
    
    func isUserSignedIn() -> Bool {
        return authentication.isUserSignedIn()
    }
    
    func signUserOut() {
        authentication.signUserOut()
    }
    
}
