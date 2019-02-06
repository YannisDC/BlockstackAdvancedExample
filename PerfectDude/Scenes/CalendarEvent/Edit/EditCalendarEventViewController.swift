//
//  EditCalendarEventViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 05/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa

final class EditCalendarEventViewController: ViewController {
    internal var viewModel: EditCalendarEventViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    internal var editButton: UIBarButtonItem!
    internal var deleteButton: UIBarButtonItem!
}

extension EditCalendarEventViewController: Bindable {

    func bindViewModel() {
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
        
        let deleteTrigger = deleteButton.rx.tap.flatMap {
            return Observable<Void>.create { observer in
                
                let alert = UIAlertController(title: "Delete Event",
                                              message: "Are you sure you want to delete this event?",
                                              preferredStyle: .alert
                )
                let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { _ -> () in observer.onNext(()) })
                let noAction = UIAlertAction(title: "No", style: .cancel)
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                self.present(alert, animated: true, completion: nil)
                
                return Disposables.create()
            }
        }
        
        let input = EditCalendarEventViewModel.Input(deleteTrigger: deleteTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)

        output.title.drive(rx.title).disposed(by: disposeBag)
        output.delete.drive().disposed(by: disposeBag)
        output.dismiss.drive().disposed(by: disposeBag)
    }
}
