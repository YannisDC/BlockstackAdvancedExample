//
//  UseCaseProvider.swift
//  MockPlatform
//
//  Created by Yannis De Cleene on 13/03/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

public final class UseCaseProvider: Core.UseCaseProvider {
    
    public init() { }
    
    public func makeAuthUseCase() -> Core.AuthUseCase {
        return AuthUseCase()
    }
    
    public func makeProfileUseCase() -> Core.ProfileUseCase {
        return ProfileUseCase()
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
