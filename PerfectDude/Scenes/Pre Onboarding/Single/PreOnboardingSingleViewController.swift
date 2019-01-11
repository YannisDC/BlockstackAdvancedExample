//
//  PreOnboardingSingleViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 12/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PerfectUI

final class PreOnboardingSingleViewController: ViewController {
    internal var viewModel: PreOnboardingSingleViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet var firstStepView: PreOnboardingStepView!
    @IBOutlet private weak var continueButton: UIButton!
}

extension PreOnboardingSingleViewController: Bindable {

    func bindViewModel() {
        let input = PreOnboardingSingleViewModel.Input(buttonTap: continueButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        output.tapResult.drive().disposed(by: disposeBag)
        output.title.drive(rx.title).disposed(by: disposeBag)
    }
}
