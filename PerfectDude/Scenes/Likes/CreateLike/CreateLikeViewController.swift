//
//  CreateLikeViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 21/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateLikeViewController: ViewController {
    internal var viewModel: CreateLikeViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var selectImageButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var descriptionTextField: UITextField!
}

extension CreateLikeViewController: Bindable {

    func bindViewModel() {
        let input = CreateLikeViewModel.Input(cancelTrigger: cancelButton.rx.tap.asDriver(),
                                              saveTrigger: saveButton.rx.tap.asDriver(),
                                              selectImageTrigger: selectImageButton.rx.tap.asDriver(),
                                              title: descriptionTextField.rx.text.orEmpty.asDriver())
        let output = viewModel.transform(input: input)

        [output.title.drive(rx.title),
         output.dismiss.drive(),
         output.saveEnabled.drive(saveButton.rx.isEnabled),
         output.selectImage.drive(),
         output.imageToSave.drive(imageView.rx.image)]
            .forEach({$0.disposed(by: disposeBag)})
    }
}
