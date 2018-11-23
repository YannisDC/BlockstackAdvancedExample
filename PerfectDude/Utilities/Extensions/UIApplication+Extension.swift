//
//  UIApplication+Extension.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var versionNumber: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "unknown"
        }
        return version
    }
    
    static var osVersion: String {
        let info = Bundle.main.infoDictionary
        let bundleVersion = info?["CFBundleShortVersionString"] as? String
        let iosVersion = UIDevice.current.systemVersion
        let device = UIDevice.current.model
        return "iOS \(device):\(iosVersion) \(bundleVersion ?? "")"
    }
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
