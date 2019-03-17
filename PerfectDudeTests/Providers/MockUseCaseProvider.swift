//
//  MockUseCaseProvider.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 31/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import XCTest
@testable import PerfectDude
@testable import Core
import RxSwift

final class MockUseCaseProvider: Core.UseCaseProvider {
    
    func makeProfileUseCase() -> ProfileUseCase {
        return MockProfileUseCase()
    }
    
    func makeAuthUseCase() -> AuthUseCase {
        return MockAuthUseCase()
    }
    
    func makeInitUseCase() -> InitUseCase {
        return MockInitUseCase()
    }
    
    func makeLikesUseCase() -> LikesUseCase {
        return MockLikesUseCase()
    }
    
    func makeCalendarEventsUseCase() -> CalendarEventsUseCase {
        return MockCalendarEventsUseCase()
    }
    
}
