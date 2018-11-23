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

final class HomeViewController: ViewController {
    
    internal var viewModel: HomeViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var signOut: UIButton!
    @IBOutlet private weak var showCard: UIButton!
    @IBOutlet var imageView: UIImageView!
}

extension HomeViewController: Bindable {
    
    func bindViewModel() {
        let input = HomeViewModel.Input(buttonTap: button.rx.tap.asDriver(),
                                        signOutTap: signOut.rx.tap.asDriver(),
                                        showTap: showCard.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.tapResult.drive().disposed(by: disposeBag)
        output.signOutResult.drive().disposed(by: disposeBag)
//        output.showResult.drive().disposed(by: disposeBag)
        output.title.drive(rx.title).disposed(by: disposeBag)
//        output.image.drive(imageView.rx.image).disposed(by: disposeBag)
//        output.imageToSave.drive(imageView.rx.image).disposed(by: disposeBag)
//        output.uploadConfirmation.drive().disposed(by: disposeBag)
    }
}
