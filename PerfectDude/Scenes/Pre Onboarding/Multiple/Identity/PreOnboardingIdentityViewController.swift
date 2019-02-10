//
//  PreOnboardingIdentityViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 06/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PreOnboardingIdentityViewController: ViewController {
    internal var viewModel: PreOnboardingIdentityViewModel!
    fileprivate let disposeBag = DisposeBag()
}

extension PreOnboardingIdentityViewController: Bindable {

    func bindViewModel() {
        let input = PreOnboardingIdentityViewModel.Input()
        let output = viewModel.transform(input: input)

        output.title.drive(rx.title).disposed(by: disposeBag)
    }
}
