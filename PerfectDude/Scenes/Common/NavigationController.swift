//
//  NavigationController.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar <- {
            $0.shadowImage = UIImage()
            $0.isTranslucent = false
            $0.tintColor = .white
            $0.barStyle = .default
        }
    }
}
