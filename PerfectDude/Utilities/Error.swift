//
//  Error.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation

public enum PerfectDudeError: Swift.Error {
    case undefined
    case custom(message: String)
}

public enum BlockstackError: Swift.Error {
    case undefined
    case custom(message: String)
}
