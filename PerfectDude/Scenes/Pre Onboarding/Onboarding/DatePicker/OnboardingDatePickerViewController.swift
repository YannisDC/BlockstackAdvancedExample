//
//  OnboardingDatePickerViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 09/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PerfectUI

final class OnboardingDatePickerViewController: ViewController {
    internal var viewModel: BaseDatePickerViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var continueButton: UIButton!
    
    var loadingBinding: Binder<Void> {
        return Binder(self, binding: { (vc, _ ) in
            vc.continueButton.isEnabled = false
        })
    }
}

extension OnboardingDatePickerViewController: Bindable {

    func bindViewModel() {
        continueButton.setTitle("Loading", for: .disabled)
        
        let input = BaseDatePickerViewModel.Input(selection: datePicker.rx.date.asDriver(),
                                                  continueTrigger: continueButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        output.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
//        output.continueButtonTitle.drive(continueButton).disposed(by: disposeBag)
        output.continueResult.drive().disposed(by: disposeBag)
        output.disableTrigger.drive(loadingBinding).disposed(by: disposeBag)
    }
}
