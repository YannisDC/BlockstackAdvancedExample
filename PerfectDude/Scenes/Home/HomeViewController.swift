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
import Core
import PerfectUI

final class HomeViewController: ViewController {
    
    internal var viewModel: HomeViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    internal var editButton: UIBarButtonItem!
    internal var signOut: UIBarButtonItem!
    @IBOutlet private weak var showCard: UIButton!
    @IBOutlet private weak var profileType: UISegmentedControl!
    @IBOutlet private weak var relationshipType: UISegmentedControl!
    
    @IBOutlet private weak var firstOptionView: ProfileToggleView!
    @IBOutlet private weak var secondOptionView: ProfileToggleView!
    @IBOutlet private weak var thirdOptionView: ProfileToggleView!
    @IBOutlet private weak var fourthOptionView: ProfileToggleView!
    @IBOutlet private weak var fifthOptionView: ProfileToggleView!
    @IBOutlet private weak var sixthOptionView: ProfileToggleView!
    
    var initBinding: Binder<Void> {
        return Binder(self, binding: { (vc, _ ) in
            let modalView = ModalStatusView(frame: vc.view.bounds)
            modalView.set(image: UIImage(named: "download")!)
            modalView.set(header: "Reset")
            modalView.set(subheader: "The app was successfully reset")
            vc.view.addSubview(modalView)
        })
    }
    
    var settingsBinding: Binder<Profile> {
        return Binder(self, binding: { (vc, profile ) in
            print(profile)
            switch profile.personType {
            case .donJuan:
                vc.profileType.selectedSegmentIndex = 0
            case .playItCool:
                vc.profileType.selectedSegmentIndex = 1
            case .iDontCare:
                vc.profileType.selectedSegmentIndex = 2
            }
            
            switch profile.maritialStatus {
            case .married:
                vc.relationshipType.selectedSegmentIndex = 0
            case .livingTogether:
                vc.relationshipType.selectedSegmentIndex = 1
            case .relationship:
                vc.relationshipType.selectedSegmentIndex = 2
            }
        })
    }
    
    var enableBinding: Binder<Bool> {
        return Binder(self, binding: { (vc, isEnabled ) in
            vc.profileType.isEnabled = isEnabled
            vc.relationshipType.isEnabled = isEnabled
            vc.firstOptionView.switchButton.isEnabled = isEnabled
            vc.secondOptionView.switchButton.isEnabled = isEnabled
            vc.thirdOptionView.switchButton.isEnabled = isEnabled
            vc.fourthOptionView.switchButton.isEnabled = isEnabled
            vc.fifthOptionView.switchButton.isEnabled = isEnabled
            vc.sixthOptionView.switchButton.isEnabled = isEnabled
        })
    }
}

extension HomeViewController: Bindable {
    
    func bindViewModel() {
        extendedLayoutIncludesOpaqueBars = false
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
        signOut = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [signOut, editButton]
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let signOutTrigger = signOut.rx.tap.flatMap {
            return Observable<Void>.create { observer in
                
                let alert = UIAlertController(title: "Sign Out",
                                              message: "Are you sure you want to sign out?",
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
        
        let input = HomeViewModel.Input(trigger: viewWillAppear,
                                        editTrigger: editButton.rx.tap.asDriver(),
                                        signOutTap: signOutTrigger.asDriverOnErrorJustComplete(),
                                        personType: profileType.rx.selectedSegmentIndex.asDriver(),
                                        relationshipType: relationshipType.rx.selectedSegmentIndex.asDriver(),
                                        notificationsToggle: firstOptionView.switchButton.rx.isOn.asDriver(),
                                        birthdayToggle: secondOptionView.switchButton.rx.isOn.asDriver(),
                                        anniversaryToggle: thirdOptionView.switchButton.rx.isOn.asDriver(),
                                        marriageToggle: fourthOptionView.switchButton.rx.isOn.asDriver(),
                                        flowerToggle: fifthOptionView.switchButton.rx.isOn.asDriver(),
                                        surpriseToggle: sixthOptionView.switchButton.rx.isOn.asDriver(),
                                        showTap: showCard.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.editButtonTitle.drive(editButton.rx.title).disposed(by: disposeBag)
        output.editing.drive(enableBinding).disposed(by: disposeBag)
        output.save.drive().disposed(by: disposeBag)
        output.signOutResult.drive().disposed(by: disposeBag)
        output.showResult.drive(initBinding).disposed(by: disposeBag)
        output.title.drive(rx.title).disposed(by: disposeBag)
        output.profile.drive(settingsBinding).disposed(by: disposeBag)
        output.notificationsToggle.drive(firstOptionView.switchButton.rx.isOn).disposed(by: disposeBag)
        output.birthdayToggle.drive(secondOptionView.switchButton.rx.isOn).disposed(by: disposeBag)
        output.anniversaryToggle.drive(thirdOptionView.switchButton.rx.isOn).disposed(by: disposeBag)
        output.marriageToggle.drive(fourthOptionView.switchButton.rx.isOn).disposed(by: disposeBag)
        output.flowerToggle.drive(fifthOptionView.switchButton.rx.isOn).disposed(by: disposeBag)
        output.surpriseToggle.drive(sixthOptionView.switchButton.rx.isOn).disposed(by: disposeBag)
    }
}
