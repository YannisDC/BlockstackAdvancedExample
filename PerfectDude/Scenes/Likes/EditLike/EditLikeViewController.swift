//
//  EditLikeViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 21/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa

final class EditLikeViewController: ViewController {
    internal var viewModel: EditLikeViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    internal var editButton: UIBarButtonItem!
    internal var deleteButton: UIBarButtonItem!
    
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var selectImageButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    
    var likeBinding: Binder<Like> {
        return Binder(self, binding: { (vc, like) in
            vc.titleTextField.text = like.description
            vc.imageView.image = like.image
        })
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, _) in
            let alert = UIAlertController(title: "Save Error",
                                          message: "Something went wrong",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss",
                                       style: UIAlertAction.Style.cancel,
                                       handler: nil)
            alert.addAction(action)
            vc.present(alert, animated: true, completion: nil)
        })
    }
}

extension EditLikeViewController: Bindable {

    func bindViewModel() {
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
        
        let deleteTrigger = deleteButton.rx.tap.flatMap {
            return Observable<Void>.create { observer in
                
                let alert = UIAlertController(title: "Delete Post",
                                              message: "Are you sure you want to delete this post?",
                                              preferredStyle: .alert
                )
                let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { _ -> () in observer.onNext(()) })
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: { _ -> () in observer.onNext(()) })
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                self.present(alert, animated: true, completion: nil)
                
                return Disposables.create()
            }
        }
        
        let input = EditLikeViewModel.Input(cancelTrigger: cancelButton.rx.tap.asDriver(),
                                            editTrigger: editButton.rx.tap.asDriver(),
                                            deleteTrigger: deleteTrigger.asDriverOnErrorJustComplete(),
                                            title: titleTextField.rx.text.orEmpty.asDriver(),
                                            selectImageTrigger: selectImageButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.editButtonTitle.drive(editButton.rx.title).disposed(by: disposeBag)
        output.editing.drive(titleTextField.rx.isEnabled).disposed(by: disposeBag)
        output.editing.drive(selectImageButton.rx.isEnabled).disposed(by: disposeBag)
        output.like.drive(likeBinding).disposed(by: disposeBag)
        output.dismiss.drive().disposed(by: disposeBag)
        output.save.drive().disposed(by: disposeBag)
        output.error.drive(errorBinding).disposed(by: disposeBag)
        output.delete.drive().disposed(by: disposeBag)
    }
}
