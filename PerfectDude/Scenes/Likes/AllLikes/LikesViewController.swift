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
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var newLikeButton: UIButton!
}

extension LikesViewController: Bindable {

    func bindViewModel() {
        tableView.register(UINib(nibName: LikeTableViewCell.reuseID, bundle: nil), forCellReuseIdentifier: LikeTableViewCell.reuseID)
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let input = LikesViewModel.Input(trigger: Driver.merge(viewWillAppear, pull),
                                         createLikeTrigger: newLikeButton.rx.tap.asDriver(),
                                         selection: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)

        output.title.drive(rx.title).disposed(by: disposeBag)
        
        output.likes.drive(tableView.rx.items(cellIdentifier: LikeTableViewCell.reuseID, cellType: LikeTableViewCell.self)) { tv, viewModel, cell in
            cell.bind(viewModel)
            }.disposed(by: disposeBag)

        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        output.createLike
            .drive()
            .disposed(by: disposeBag)
        output.selectedLike
            .drive()
            .disposed(by: disposeBag)
    }
}
