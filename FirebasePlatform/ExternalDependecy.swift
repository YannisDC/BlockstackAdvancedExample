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

public final class ExternalDependency: Core.ExternalDependenciesInjection {
    
    public init() { }
    
    public func setup() {
        FirebaseApp.configure()
    }
    
    public func print(error: Error) {
        
    }
    
    public func track(event: String) {
        
    }
}
