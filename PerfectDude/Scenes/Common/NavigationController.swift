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
            $0.tintColor = .black
            $0.barStyle = .default
            $0.prefersLargeTitles = true
            $0.backgroundColor = .white
        }
        
        navigationItem <- {
            $0.largeTitleDisplayMode = .always
        }
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }
}
