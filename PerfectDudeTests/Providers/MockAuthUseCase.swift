//
//  MockAuthUseCase.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 31/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import XCTest
@testable import PerfectDude
@testable import Core
import RxSwift

final class MockAuthUseCase: Core.AuthUseCase {
    func signIn() -> Single<Void> {
        return Single.create { single in
            single(.success(()))
            return Disposables.create()
        }
    }
    
    func isUserSignedIn() -> Bool {
        return true
    }
    
    func signUserOut() {}
}
