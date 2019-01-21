//
//  CalendarEventsViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 20/01/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CalendarEventsViewController: ViewController {
    internal var viewModel: CalendarEventsViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    internal var createCalendarEventButton: UIBarButtonItem!
}

extension CalendarEventsViewController: Bindable {

    func bindViewModel() {
        extendedLayoutIncludesOpaqueBars = false
        createCalendarEventButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItem = createCalendarEventButton
        
        let input = CalendarEventsViewModel.Input(createCalendarEventTrigger: createCalendarEventButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        output.title.drive(rx.title).disposed(by: disposeBag)
        output.createCalendarEvent.drive().disposed(by: disposeBag)
    }
}
