//
//  NSObject+Extension.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation

extension NSObject {
    @objc var className: String {
        return type(of: self).className
    }
    
    @objc class var className: String {
        let base = String(describing: self)
        return base.components(separatedBy: ".").last ?? base
    }
}
