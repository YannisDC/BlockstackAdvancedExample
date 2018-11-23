//
//  CustomViewable.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
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
