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
    @IBOutlet private weak var tableView: UITableView!
}

extension CalendarEventsViewController: Bindable {

    func bindViewModel() {
        extendedLayoutIncludesOpaqueBars = false
        createCalendarEventButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItem = createCalendarEventButton
        
        tableView.register(UINib(nibName: CalendarEventTableViewCell.reuseID, bundle: nil),
                           forCellReuseIdentifier: CalendarEventTableViewCell.reuseID)
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 20)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let input = CalendarEventsViewModel.Input(trigger: Driver.merge(viewWillAppear, pull),
                                                  createCalendarEventTrigger: createCalendarEventButton.rx.tap.asDriver(),
                                                  selection: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)
        
        
        output.title.drive(rx.title).disposed(by: disposeBag)
        output.calendarEvents.drive(tableView.rx.items(cellIdentifier: CalendarEventTableViewCell.reuseID,
                                              cellType: CalendarEventTableViewCell.self)) { tv, viewModel, cell in
                                                cell.bind(viewModel)
            }
            .disposed(by: disposeBag)
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        output.createCalendarEvent
            .drive()
            .disposed(by: disposeBag)
        output.selectedCalendarEvent
            .drive()
            .disposed(by: disposeBag)
    }
}
