//
//  CALayer.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import UIKit

struct SketchShadow {
    var color: UIColor = .black
    var alpha: Float = 0.15
    var offset: CGSize = CGSize(width: 0, height: 5)
    var blur: CGFloat = 10.0
    var spread: CGFloat = -6.0
}

extension CALayer {
    func applySketchShadow(shadow: SketchShadow = SketchShadow()) {
        shadowColor = shadow.color.cgColor
        shadowOpacity = shadow.alpha
        shadowOffset = shadow.offset
        shadowRadius = shadow.blur / 2.0
        if shadow.spread == 0 {
            shadowPath = nil
        } else {
            let dx = -shadow.spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
