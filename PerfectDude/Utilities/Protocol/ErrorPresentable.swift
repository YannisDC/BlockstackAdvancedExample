//
//  ErrorPresentable.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ErrorPresentable {
    // If we need to handle specific errorviews we will do it here
}

// MARK: - UIViewController

extension ErrorPresentable where Self: UIViewController {
    
    var errorAlertBinding: Binder<Error> {
        return Binder(self, binding: { vc, error in
            var message = error.localizedDescription
            
            defer {
                vc.showAlert(message: message)
            }
            
            if case PerfectDudeError.custom(let customMessage) = error {
                message = customMessage
                return
            }
            
            if let error = error as? PerfectDudeError {
                message = error.errorDescription ?? "general_error".localized()
                return
            }
        })
    }
}
