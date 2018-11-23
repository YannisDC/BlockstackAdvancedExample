//
//  CustomView.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import UIKit
/// Baseclass to support Nib loading
@IBDesignable
class CustomView: UIView {
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // MARK: NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
// MARK: CustomViewable
extension CustomView: CustomViewable {
    
    var contentView: UIView {
        return self
    }
    
    func nibIdentifier() -> String {
        // swiftlint:disable:next force_unwrapping
        return type(of: self).description().components(separatedBy: ".").last!
    }
}
