//
//  UIViewController+Extension.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import UIKit

extension UIViewController {
    class func loadFromNib() -> Self {
        func load<T: UIViewController>(type: T.Type) -> T {
            return T(nibName: T.className, bundle: nil)
        }
        
        return load(type: self)
    }
    
    func addChild(childViewController: UIViewController?, on view: UIView) {
        guard let childViewController = childViewController else {
            return
        }
        
        addChild(childViewController)
        childViewController.view.frame = view.bounds
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childViewController.view)
        
        childViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        childViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        childViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        childViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        childViewController.didMove(toParent: self)
    }
}
