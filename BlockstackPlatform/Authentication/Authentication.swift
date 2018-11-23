//
//  Authentication.swift
//  BlockstackPlatform
//
//  Created by Yannis De Cleene on 16/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Blockstack
import RxSwift

protocol AbstractAuthentication {
    func signIn() -> Single<Void>
    func isUserSignedIn() -> Bool
    func signUserOut()
    // TODO: Add decrypt, encrypt
}

final class Authentication: AbstractAuthentication {
    
    private let configuration: Blockstack.Configuration
    private let scheduler: OperationQueueScheduler
    
    private let blockstack = Blockstack.shared
    
    init(configuration: Blockstack.Configuration) {
        self.configuration = configuration
        self.scheduler = OperationQueueScheduler(operationQueue: OperationQueue.init())
        //        print("File 📁 url: \(RLMRealmPathForFile("default.realm"))")
    }
    
    func signIn() -> Single<Void> {
        return self.blockstack.rx.signIn(with: configuration)
    }
    
    func isUserSignedIn() -> Bool {
        return self.blockstack.rx.isUserSignedIn()
    }
    
    func signUserOut(){
        self.blockstack.rx.signUserOut()
    }

}
