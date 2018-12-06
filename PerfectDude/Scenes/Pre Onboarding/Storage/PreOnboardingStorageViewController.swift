//
//  PreOnboardingStorageViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 06/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PreOnboardingStorageViewController: ViewController {
    internal var viewModel: PreOnboardingStorageViewModel!
    fileprivate let disposeBag = DisposeBag()
}

extension PreOnboardingStorageViewController: Bindable {

    func bindViewModel() {
        let input = PreOnboardingStorageViewModel.Input()
        let output = viewModel.transform(input: input)

        output.title.drive(rx.title).disposed(by: disposeBag)
    }
}
