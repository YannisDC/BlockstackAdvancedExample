//
//  TestUseCaseProvider.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 31/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import XCTest
@testable import PerfectDude
@testable import Core
import RxSwift

final class TestUseCaseProvider: Core.UseCaseProvider {
    
    func makeAuthUseCase() -> AuthUseCase {
        return TestAuthUseCase()
    }
    
    func makeInitUseCase() -> InitUseCase {
        return TestInitUseCase()
    }
    
    func makeLikesUseCase() -> LikesUseCase {
        return TestLikesUseCase()
    }
    
    func makeCalendarEventsUseCase() -> CalendarEventsUseCase {
        return TestCalendarEventsUseCase()
    }
    
}
