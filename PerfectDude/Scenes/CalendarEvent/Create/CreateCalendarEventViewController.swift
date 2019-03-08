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
    internal var viewModel: CalendarEventViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    internal var editButton: UIBarButtonItem!
    internal var deleteButton: UIBarButtonItem!
    
    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var frequencyPicker: UIPickerView!
}

extension CreateCalendarEventViewController: Bindable {

    func bindViewModel() {
//        KeyboardAvoiding.avoidingView = self.view
        
        editButton = UIBarButtonItem(title: "edit".localized(), style: .plain, target: self, action: nil)
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        navigationItem.rightBarButtonItems = [editButton, deleteButton]

        let deleteTrigger = deleteButton.rx.tap.flatMap {
            return Observable<Void>.create { observer in
                
                let alert = UIAlertController(title: "delete_event".localized(),
                                              message: "delete_event_sure".localized(),
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
        
        let input = CalendarEventViewModel.Input(editTrigger: editButton.rx.tap.asDriver(),
                                                 deleteTrigger: deleteTrigger.asDriverOnErrorJustComplete(),
                                                 calendarEventTitle: descriptionTextField.rx.text.orEmpty.asDriver(),
                                                 calendarEventDate: datePicker.rx.date.asDriver(),
                                                 selection: frequencyPicker.rx.modelSelected(CustomStringConvertible.self).asDriver())
        let output = viewModel.transform(input: input)

        output.title.drive(rx.title).disposed(by: disposeBag)
        output.dismiss.drive().disposed(by: disposeBag)
//        output.delete.drive().disposed(by: disposeBag)
        output.date.drive(datePicker.rx.date).disposed(by: disposeBag)
        output.eventDescription.drive(descriptionTextField.rx.text).disposed(by: disposeBag)
        output.calendarEvents.drive(frequencyPicker.rx.items(adapter: PickerViewViewAdapter())).disposed(by: disposeBag)
        
        output.isUpdating.drive(deleteButton.rx.isEnabled).disposed(by: disposeBag)
        output.isUpdating.drive(deleteButton.rx.isVisible).disposed(by: disposeBag)
        output.editButtonTitle.drive(editButton.rx.title).disposed(by: disposeBag)
        output.isEditing.drive(descriptionTextField.rx.isEnabled).disposed(by: disposeBag)
        output.isEditing.drive(datePicker.rx.isEnabled).disposed(by: disposeBag)
    }
}
