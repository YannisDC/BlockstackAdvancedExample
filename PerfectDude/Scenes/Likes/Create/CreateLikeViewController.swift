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
    internal var viewModel: LikeViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    internal var editButton: UIBarButtonItem!
    internal var deleteButton: UIBarButtonItem!
    internal var addTagButton: UIBarButtonItem!
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var selectImageButton: UIButton!
    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var taglistView: TagListView!
    @IBOutlet private weak var newTagTextField: UITextField!
    @IBOutlet private weak var encryptionSwitch: UISwitch!
}

extension CreateLikeViewController: Bindable,
    ErrorPresentable,
    ActivityPresentable {

    func bindViewModel() {
        KeyboardAvoiding.avoidingView = self.view
        
        editButton = UIBarButtonItem(title: "edit".localized(), style: .plain, target: self, action: nil)
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
        
        addToolbarForTags()
        
        let deleteTrigger = deleteButton.rx.tap.flatMap {
            return Observable<Void>.create { observer in
                
                let alert = UIAlertController(title: "delete_post".localized(),
                                              message: "delete_post_sure".localized(),
                                              preferredStyle: .alert
                )
                let yesAction = UIAlertAction(title: "yes".localized(), style: .destructive, handler: { _ -> () in observer.onNext(()) })
                let noAction = UIAlertAction(title: "no".localized(), style: .cancel)
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                self.present(alert, animated: true, completion: nil)
                
                return Disposables.create()
            }
        }
        
        let input = LikeViewModel.Input(trigger: Driver<Void>.just(()),
                                        editTrigger: editButton.rx.tap.asDriver(),
                                        deleteTrigger: deleteTrigger.asDriverOnErrorJustComplete(),
                                        selectImageTrigger: selectImageButton.rx.tap.asDriver(),
                                        likeTitle: descriptionTextField.rx.text.orEmpty.asDriver(),
                                        tags: taglistView.rx.tagViewsValues.asDriver(),
                                        encryption: encryptionSwitch.rx.value.asDriver(),
                                        tagDeleteTrigger: taglistView.rx.didRemoveTagView.asDriver(),
                                        newTagTitle: newTagTextField.rx.text.orEmpty.asDriver(),
                                        newTagTrigger: addTagButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        [output.title.drive(rx.title),
         output.dismiss.drive(),
         output.saveEnabled.drive(editButton.rx.isEnabled),
         output.isUpdating.drive(deleteButton.rx.isEnabled),
         output.isUpdating.drive(deleteButton.rx.isVisible),
         output.selectImage.drive(),
         output.imageToSave.drive(imageView.rx.image)]
            .forEach({$0.disposed(by: disposeBag)})
        
        output.editButtonTitle.drive(editButton.rx.title).disposed(by: disposeBag)
        
        output.tags.drive(taglistView.rx.tagViewsValues).disposed(by: disposeBag)
        output.tagDeleteResult.drive().disposed(by: disposeBag)
        output.newTagTitle.drive(newTagTextField.rx.text).disposed(by: disposeBag)
        output.newTagTrigger.drive().disposed(by: disposeBag)
        
        output.error.drive(errorAlertBinding).disposed(by: disposeBag)
        output.fetching.drive(activityBinding).disposed(by: disposeBag)
        
        
        output.isEditing.drive(selectImageButton.rx.isEnabled).disposed(by: disposeBag)
        output.isEditing.drive(descriptionTextField.rx.isEnabled).disposed(by: disposeBag)
        output.isEditing.drive(newTagTextField.rx.isEnabled).disposed(by: disposeBag)
        output.isEditing.drive(encryptionSwitch.rx.isEnabled).disposed(by: disposeBag)
        
        output.likeTitle.drive(descriptionTextField.rx.text).disposed(by: disposeBag)
        output.encryption.drive(encryptionSwitch.rx.isOn).disposed(by: disposeBag)
        
        output.save.drive().disposed(by: disposeBag)
        output.delete.drive().disposed(by: disposeBag)
    }
    
    func addToolbarForTags() {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        numberToolbar.barStyle = .default
        
        addTagButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: nil)
        addTagButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "PoisonGreen"),
                                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], for: .normal)
        
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            addTagButton
        ]
        numberToolbar.sizeToFit()
        newTagTextField.inputAccessoryView = numberToolbar
    }
}
