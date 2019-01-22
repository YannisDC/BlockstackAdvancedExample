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
import FirebaseAuth

final class AuthUseCase: Core.AuthUseCase {
    func signIn() -> Single<Void> {
        return Single.create { single in
            Auth.auth().signIn(withEmail: "test@test.com", password: "test1234") { (authResult, error) in
                guard let user = authResult?.user else {
                    single(.error(FirebaseError.general))
                    return
                }
                single(.success(()))
            }
            return Disposables.create()
        }
    }
    
    func isUserSignedIn() -> Bool {
        return (Auth.auth().currentUser != nil)
    }
    
    func signUserOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
