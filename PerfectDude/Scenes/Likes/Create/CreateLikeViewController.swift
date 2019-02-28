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
import PerfectUI
import IHKeyboardAvoiding
import TagListView

final class CreateLikeViewController: ViewController {
    internal var viewModel: CreateLikeViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    internal var editButton: UIBarButtonItem!
    internal var deleteButton: UIBarButtonItem!
    internal var saveButton: UIBarButtonItem!
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var selectImageButton: UIButton!
    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var encryptionSwitch: UISwitch!
    @IBOutlet private weak var taglistView: TagListView!
    
    @IBOutlet var newTagTextField: UITextField!
    @IBOutlet var addTagButton: UIButton!
}

extension CreateLikeViewController: Bindable,
    ErrorPresentable,
    ActivityPresentable {

    func bindViewModel() {
        KeyboardAvoiding.avoidingView = self.view
        
//        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
//        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
//        navigationItem.rightBarButtonItems = [editButton, deleteButton]
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
        navigationItem.rightBarButtonItem = saveButton
        
        let input = CreateLikeViewModel.Input(saveTrigger: saveButton.rx.tap.asDriver(),
                                              selectImageTrigger: selectImageButton.rx.tap.asDriver(),
                                              likeTitle: descriptionTextField.rx.text.orEmpty.asDriver(),
                                              encryption: encryptionSwitch.rx.value.asDriver(),
                                              tags: taglistView.rx.tagViewsValues.asDriver(),
                                              tagDeleteTrigger: taglistView.rx.didRemoveTagView.asDriver(),
                                              newTagTitle: newTagTextField.rx.text.orEmpty.asDriver(),
                                              newTagTrigger: addTagButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        [output.title.drive(rx.title),
         output.dismiss.drive(),
         output.saveEnabled.drive(saveButton.rx.isEnabled),
         output.selectImage.drive(),
         output.imageToSave.drive(imageView.rx.image)]
            .forEach({$0.disposed(by: disposeBag)})
        
        output.tags.drive(taglistView.rx.tagViewsValues).disposed(by: disposeBag)
        output.tagDeleteResult.drive().disposed(by: disposeBag)
        output.newTagTitle.drive(newTagTextField.rx.text).disposed(by: disposeBag)
        output.newTagTrigger.drive().disposed(by: disposeBag)
        
        output.error.drive(errorAlertBinding).disposed(by: disposeBag)
        output.fetching.drive(activityBinding).disposed(by: disposeBag)
    }
}
