//
//  UIColor+Extension.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 21/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import UIKit

extension UIColor {
    static var textPrimary: UIColor {
        return UIColor(named: "TextPrimary") ?? UIColor.black
    }
    
    static var textSecondary: UIColor {
        return UIColor(named: "TextSecondary") ?? UIColor.black
    }
}
