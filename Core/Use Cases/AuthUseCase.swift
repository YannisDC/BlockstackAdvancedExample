//
//  AuthUseCase.swift
//  Core
//
//  Created by Yannis De Cleene on 16/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import RxSwift

public protocol AuthUseCase {
    
    func signIn() -> Single<Void> // UserData convertible
    func isUserSignedIn() -> Bool
    func signUserOut()
    
}
