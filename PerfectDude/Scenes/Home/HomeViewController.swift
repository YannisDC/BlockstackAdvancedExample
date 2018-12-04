//
//  HomeViewController.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PerfectUI

final class HomeViewController: ViewController {
    
    internal var viewModel: HomeViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet private weak var signOut: UIButton!
    @IBOutlet private weak var showCard: UIButton!
    
    var initBinding: Binder<Void> {
        return Binder(self, binding: { (vc, _ ) in
            let modalView = ModalStatusView(frame: vc.view.bounds)
            modalView.set(image: UIImage(named: "download")!)
            modalView.set(header: "Reset")
            modalView.set(subheader: "The app was successfully reset")
            vc.view.addSubview(modalView)
        })
    }
}

extension HomeViewController: Bindable {
    
    func bindViewModel() {
        let input = HomeViewModel.Input(signOutTap: signOut.rx.tap.asDriver(),
                                        showTap: showCard.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.signOutResult.drive().disposed(by: disposeBag)
        output.showResult.drive(initBinding).disposed(by: disposeBag)
        output.title.drive(rx.title).disposed(by: disposeBag)
    }
}
