//
//  ExternalDependecy.swift
//  FirebasePlatform
//
//  Created by Yannis De Cleene on 21/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import Firebase

final class ExternalDependency: Core.ExternalDependenciesInjection {
    
    public init() { }
    
    func setup() {
        FirebaseApp.configure()
    }
    
    func print(error: Error) {
        
    }
    
    func track(event: String) {
        
    }
}
