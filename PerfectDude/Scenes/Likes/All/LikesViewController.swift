//
//  LikesViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 21/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LikesViewController: ViewController {
    internal var viewModel: LikesViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    internal var createLikeButton: UIBarButtonItem!
    
    @IBOutlet var tableView: UITableView!
    
    fileprivate var fetchingBinding: Binder<Bool> {
        return Binder(self, binding: { _, isFetching in
            UIApplication.shared.isNetworkActivityIndicatorVisible = isFetching
        })
    }
}

extension LikesViewController: Bindable {

    func bindViewModel() {
        extendedLayoutIncludesOpaqueBars = false
        createLikeButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItem = createLikeButton
        
        tableView.register(UINib(nibName: LikeTableViewCell.reuseID, bundle: nil),
                           forCellReuseIdentifier: LikeTableViewCell.reuseID)
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let input = LikesViewModel.Input(trigger: Driver.merge(viewWillAppear, pull),
                                         createLikeTrigger: createLikeButton.rx.tap.asDriver(),
                                         selection: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)
        
        
        output.title.drive(rx.title).disposed(by: disposeBag)
        output.likes.drive(tableView.rx.items(cellIdentifier: LikeTableViewCell.reuseID,
                                              cellType: LikeTableViewCell.self)) { tv, viewModel, cell in
                                                cell.bind(viewModel)
            }
            .disposed(by: disposeBag)
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        output.fetching
            .drive(fetchingBinding)
            .disposed(by: disposeBag)
        output.createLike
            .drive()
            .disposed(by: disposeBag)
        output.selectedLike
            .drive()
            .disposed(by: disposeBag)
    }
}
