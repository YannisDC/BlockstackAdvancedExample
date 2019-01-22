//
//  UseCaseProvider.swift
//  FirebasePlatform
//
//  Created by Yannis De Cleene on 21/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import Firebase

public final class UseCaseProvider: Core.UseCaseProvider {
    
//    private var ref: DatabaseReference!
//    private var storage: StorageReference
    
    public init() {
//        ref = Database.database().reference()
//        storage = Storage.storage().reference()
    }
    
    public func makeAuthUseCase() -> Core.AuthUseCase {
        return AuthUseCase()
    }
    
    public func makeInitUseCase() -> Core.InitUseCase {
        return InitUseCase()
    }
    
    public func makeLikesUseCase() -> Core.LikesUseCase {
        return LikesUseCase()
    }
    
    public func makeCalendarEventsUseCase() -> Core.CalendarEventsUseCase {
        return CalendarEventsUseCase()
    }
}
