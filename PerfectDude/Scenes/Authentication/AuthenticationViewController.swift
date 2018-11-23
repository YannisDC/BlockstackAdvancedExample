//
//  AuthenticationViewController.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AuthenticationViewController: ViewController {
    
    internal var viewModel: AuthenticationViewModel!
    fileprivate let disposeBag = DisposeBag()
    @IBOutlet private weak var button: UIButton!
}

extension AuthenticationViewController: Bindable {
    
    func bindViewModel() {
        let input = AuthenticationViewModel.Input(buttonTap: button.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.tapResult.drive().disposed(by: disposeBag)
        output.title.drive(rx.title).disposed(by: disposeBag)
    }
}
