//
//  AlertController+Extension.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import UIKit

@objc extension UIAlertController {
    convenience init(error: Error, actionHandler: (() -> Void)? = nil) {
        self.init(title: NSLocalizedString("Something went wrong", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (_) in
            actionHandler?()
        }
        
        addAction(okAction)
    }
    
    convenience init(title: String, message: String, cancelButton: String, otherButton: String? = nil, completion: ((_ otherButtonTapped: Bool) -> Void)? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelButton, style: .default) { (_) in
            completion?(false)
        }
        
        addAction(cancelAction)
        
        if let otherButton = otherButton {
            let otherAction = UIAlertAction(title: otherButton, style: .default) { (_) in
                completion?(true)
            }
            
            addAction(otherAction)
        }
    }
    
    @available(swift, obsoleted: 1.0)
    convenience init(title: String, message: String, cancelButton: String, completion: (() -> Void)? = nil) {
        self.init(title: title, message: message, cancelButton: cancelButton, otherButton: nil) { (_) in
            completion?()
        }
    }
    
    @objc
    func show() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.windowLevel = UIWindow.Level.alert
        window.makeKeyAndVisible()
        window.rootViewController?.present(self, animated: false, completion: nil)
    }
    convenience init(message: String) {
        self.init(title: "", message: message, preferredStyle: .alert)
    }
}

@objc extension UIViewController {
    func showAlert(error: Error, completion: (() -> Void)? = nil) {
        assert(Thread.isMainThread)
        let controller = UIAlertController(error: error, actionHandler: completion)
        self.present(controller, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, cancelButton: String, otherButton: String? = nil, completion: ((_ otherButtonTapped: Bool) -> Void)? = nil) {
        assert(Thread.isMainThread)
        let controller = UIAlertController(title: title, message: message, cancelButton: cancelButton, otherButton: otherButton, completion: completion)
        self.present(controller, animated: true, completion: nil)
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        showAlert(title: "", message: message, cancelButton: "Ok", otherButton: nil) { (_) in
            completion?()
        }
    }
    
    @available(swift, obsoleted: 1.0)
    func showAlert(title: String, message: String, cancelButton: String, completion: (() -> Void)? = nil) {
        showAlert(title: title, message: message, cancelButton: cancelButton, otherButton: nil) { (_) in
            completion?()
        }
    }
}
