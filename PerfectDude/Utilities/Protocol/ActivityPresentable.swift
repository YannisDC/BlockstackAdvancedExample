//
//  ActivityPresentable.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ActivityPresentable {
    // If we need to handle specific loading views we will do it here
}

// MARK: - UIViewController

extension ActivityPresentable where Self: UIViewController {
    
    var activityBinding: Binder<Bool> {
        return Binder(self, binding: { _, isLoading in
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        })
    }
}
