//
//  CustomView.swift
//  PerfectUI
//
//  Created by Yannis De Cleene on 13/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import UIKit

protocol CustomViewable: NSObjectProtocol {
    var contentView: UIView { get }
    func nibIdentifier() -> String
}

extension CustomViewable {
    
    // MARK: Setup
    
    func setup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibIdentifier(), bundle: bundle)
        // swiftlint:disable:next force_cast
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        var bindings = [String: Any]()
        bindings["view"] = view
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: bindings))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: bindings))
    }
}

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
