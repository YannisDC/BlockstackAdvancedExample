//
//  ModalNavigation.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 23/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import UIKit

protocol ModalNavigationControllerDelegate: class {
    /// RightBarButton was touched
    func didCancelNavigationController()
}

class ModalNavigationController: UINavigationController {
    
    weak var baseDelegate: ModalNavigationControllerDelegate?
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        setLayout(viewController: viewControllers.last)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        setLayout(viewController: viewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("DISPOSED \(NSStringFromClass(type(of: self)))")
    }
    
    private func setLayout(viewController: UIViewController?) {
        guard baseDelegate != nil else { return }
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissModal))
        viewController?.navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc
    private func dismissModal() {
        baseDelegate?.didCancelNavigationController()
    }
    
}
