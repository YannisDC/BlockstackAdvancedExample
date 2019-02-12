//
//  AuthUseCase.swift
//  Core
//
//  Created by Yannis De Cleene on 16/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import RxSwift

/// Creates AuthUseCase that takes care of the authentication of your app.
public protocol AuthUseCase {
    
    /// Signs in the user and gives back void.
    ///
    /// Should become Completable
    ///
    /// - Returns: Single<Void>
    func signIn() -> Single<Void> // UserData convertible
    
    
    /// Checks wether the user is signed in.
    ///
    /// - Returns: Bool value
    func isUserSignedIn() -> Bool
    
    
    /// Signs out the user.
    func signUserOut()
    
}
