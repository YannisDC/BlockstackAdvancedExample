//
//  AuthUseCase.swift
//  FirebasePlatform
//
//  Created by Yannis De Cleene on 21/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import Firebase

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
    
    func signUserOut() {
        
    }
}
