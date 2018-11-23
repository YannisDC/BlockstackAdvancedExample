//
//  TargetWeightViewController.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 17/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TargetWeightViewController: ViewController {
    
    internal var viewModel: TargetWeightViewModel!
    fileprivate let disposeBag = DisposeBag()
    @IBOutlet private weak var button: UIButton!
}

extension TargetWeightViewController: Bindable {
    
    func bindViewModel() {
        let input = TargetWeightViewModel.Input(buttonTap: button.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.tapResult.drive().disposed(by: disposeBag)
        output.title.drive(rx.title).disposed(by: disposeBag)
    }
}
