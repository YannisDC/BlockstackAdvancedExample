//
//  AuthUseCase.swift
//  MockPlatform
//
//  Created by Yannis De Cleene on 13/03/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class AuthUseCase: Core.AuthUseCase {
    func signIn() -> Single<Void> {
        return Single.create { single in
            single(.success(()))
            return Disposables.create()
        }
    }
    
    func isUserSignedIn() -> Bool {
        return true
    }
    
    func signUserOut() { }
}
