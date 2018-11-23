//
//  Operator.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

infix operator <-

@discardableResult
func <- <T: AnyObject>(value: T, modify: (T) -> Void) -> T {
    modify(value)
    return value
}
