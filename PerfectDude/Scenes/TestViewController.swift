//
//  TestViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 04/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TestViewController: ViewController {
    internal var viewModel: TestViewModel!
    fileprivate let disposeBag = DisposeBag()
}

extension TestViewController: Bindable {

    func bindViewModel() {
        let input = TestViewModel.Input()
        let output = viewModel.transform(input: input)

        output.title.drive(rx.title).disposed(by: disposeBag)
    }
}
