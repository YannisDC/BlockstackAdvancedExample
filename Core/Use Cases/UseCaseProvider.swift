//
//  UseCaseProvider.swift
//  Core
//
//  Created by Yannis De Cleene on 05/11/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation

public protocol UseCaseProvider {
    
    func makeAuthUseCase() -> AuthUseCase
    func makeInitUseCase() -> InitUseCase
    func makeLikesUseCase() -> LikesUseCase
    func makeCalendarEventsUseCase() -> CalendarEventsUseCase
}
