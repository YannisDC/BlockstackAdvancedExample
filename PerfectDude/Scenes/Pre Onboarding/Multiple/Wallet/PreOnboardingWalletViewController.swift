//
//  PreOnboardingWalletViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 06/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PreOnboardingWalletViewController: ViewController {
    internal var viewModel: PreOnboardingWalletViewModel!
    fileprivate let disposeBag = DisposeBag()
}

extension PreOnboardingWalletViewController: Bindable {

    func bindViewModel() {
        let input = PreOnboardingWalletViewModel.Input()
        let output = viewModel.transform(input: input)

        output.title.drive(rx.title).disposed(by: disposeBag)
    }
}
