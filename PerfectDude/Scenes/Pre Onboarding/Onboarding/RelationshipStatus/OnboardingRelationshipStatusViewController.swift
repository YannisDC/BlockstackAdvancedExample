//
//  OnboardingRelationshipStatusViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 09/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingRelationshipStatusViewController: ViewController {
    internal var viewModel: OnboardingRelationshipStatusViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet private weak var firstOptionView: SelectionButtonView!
    @IBOutlet private weak var secondOptionView: SelectionButtonView!
    @IBOutlet private weak var thirdOptionView: SelectionButtonView!
}

extension OnboardingRelationshipStatusViewController: Bindable {

    func bindViewModel() {
        firstOptionView.type = .married
        secondOptionView.type = .livingTogether
        thirdOptionView.type = .relationship
        
        let input = OnboardingRelationshipStatusViewModel.Input(firstTrigger: firstOptionView.selectionButton.rx.tap.asDriver(),
                                                                secondTrigger: secondOptionView.selectionButton.rx.tap.asDriver(),
                                                                thirdTrigger: thirdOptionView.selectionButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        output.title.drive(rx.title).disposed(by: disposeBag)
        output.selectionResult.drive().disposed(by: disposeBag)
    }
}
