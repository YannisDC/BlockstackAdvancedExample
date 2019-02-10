//
//  PreOnboardingRoute.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 05/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core

enum PreOnboardingRoute: Route {
    case overview
    case personType(profile: Profile)
    case relationshipStatus(profile: Profile)
    case birthday(profile: Profile)
    case anniversary(profile: Profile)
    case finished
}
