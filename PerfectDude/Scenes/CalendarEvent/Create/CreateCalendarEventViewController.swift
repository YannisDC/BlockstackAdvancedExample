//
//  CreateCalendarEventViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 21/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import IHKeyboardAvoiding

final class CreateCalendarEventViewController: ViewController {
    internal var viewModel: CreateCalendarEventViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet private weak var descriptionTextField: UITextField!
}

extension CreateCalendarEventViewController: Bindable {

    func bindViewModel() {
//        KeyboardAvoiding.avoidingView = self.view
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
        navigationItem.rightBarButtonItem = saveButton
        
        let input = CreateCalendarEventViewModel.Input(saveTrigger: saveButton.rx.tap.asDriver(),
                                                       calendarEventTitle: descriptionTextField.rx.text.orEmpty.asDriver())
        let output = viewModel.transform(input: input)

        output.title.drive(rx.title).disposed(by: disposeBag)
        output.dismiss.drive().disposed(by: disposeBag)
    }
}
