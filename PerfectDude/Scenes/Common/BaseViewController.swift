//
//  BaseViewController.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

//
//  BaseViewController.swift
//  Bancontact
//
//  Created by Bert Braeckevelt on 13/07/2018.
//  Copyright © 2018 In The Pocket. All rights reserved.
//

import Foundation
import UIKit

enum BaseAnimation {
    case none
    case fadeIn
}

@objc
final class BaseViewController: UIViewController {
    
    override var childForStatusBarStyle: UIViewController? {
        return contentViewController?.childForStatusBarStyle
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return contentViewController?.childForStatusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    private(set) var contentViewController: UIViewController? {
        willSet {
            contentViewController?.willMove(toParent: nil)
            newValue?.willMove(toParent: self)
        }
        didSet {
            view.backgroundColor = UIColor.white
            
            // Remove old dangling VC's
            if let children = oldValue?.children {
                children.forEach { $0.removeFromParent() }
            }
            
            // Remove from superView
            oldValue?.view.removeFromSuperview()
            oldValue?.removeFromParent()
            oldValue?.didMove(toParent: nil)
            
            // Make sure a value is set
            guard let contentViewController = contentViewController else {
                return
            }
            
            addChild(contentViewController)
            view.addSubview(contentViewController.view)
            contentViewController.view.frame = view.frame
            contentViewController.didMove(toParent: self)
        }
    }
    
    func setContentViewController(_ viewController: UIViewController?,
                                  animation: BaseAnimation = .fadeIn) {
        switch animation {
        case .none:
            dismiss(animated: false, completion: nil)
            contentViewController = viewController
        case .fadeIn:
            UIView.transition(with: view, duration: 0.3, options: [.beginFromCurrentState, .transitionCrossDissolve], animations: {
                self.dismiss(animated: false, completion: nil)
                self.contentViewController = viewController
            }, completion: nil)
        }
    }
}
