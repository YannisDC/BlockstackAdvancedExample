//
//  MealPlanError+Extension.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation

extension PerfectDudeError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .undefined: return NSLocalizedString("general_error", comment: "")
        case .custom(let message):
            return message
        }
    }
}
