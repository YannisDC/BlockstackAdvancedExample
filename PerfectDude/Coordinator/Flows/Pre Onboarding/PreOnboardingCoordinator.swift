//
//  PreOnboardingCoordinator.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 05/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

final class PreOnboardingCoordinator: BaseCoordinator<PreOnboardingRoute> {
    
    fileprivate weak var rootViewController: BaseViewController!
    fileprivate weak var delegate: CoordinatorDelegate?
    fileprivate let useCaseProvider: Core.UseCaseProvider
    fileprivate let disposeBag = DisposeBag()
    fileprivate let factory: PreOnboardingFactory
    
    let profile: Profile
    
    // MARK: - Init
    
    init(rootViewController: BaseViewController,
         delegate: CoordinatorDelegate?,
         useCaseProvider: Core.UseCaseProvider,
         factory: PreOnboardingFactory) {
        
        self.rootViewController = rootViewController
        self.delegate = delegate
        self.useCaseProvider = useCaseProvider
        self.factory = factory
        self.profile = Profile(personType: .donJuan,
                               maritialStatus: .relationship,
                               birthday: Date(),
                               anniversary: Date(),
                               reminders: Reminders())
    }
    
    // MARK: - Coordinator
    
    override func start() {
        coordinate(to: .overview)
    }
    
    override func coordinate(to route: PreOnboardingRoute) {
        DispatchQueue.main.async {
            switch route {
            case .overview:
                self.toOverView()
            case .personType(let profile):
                self.toPersonType(profile: profile)
            case .relationshipStatus(let profile):
                self.toRelationshipStatus(profile: profile)
            case .birthday(let profile):
                self.toBirthday(profile: profile)
            case .anniversary(let profile):
                self.toAnniversary(profile: profile)
            case .finished:
                self.delegate?.didFinish(coordinator: self)
            }
        }
    }
}

// MARK: - Private

private extension PreOnboardingCoordinator {
    // TODO: - Present ViewControllers
    func toOverView() {
        let preOnboardingSingleViewController = factory
            .makePreOnboardingSingleViewController(coordinator: self,
                                                   useCaseProvider: self.useCaseProvider,
                                                   profile: profile)
        rootViewController.present(preOnboardingSingleViewController, animated: false, completion: nil)
    }
    
    func toPersonType(profile: Profile) {
        let personTypeViewController = factory.makeOnboardingPersonTypeViewController(coordinator: self,
                                                                                      profile: profile)
        rootViewController.setContentViewController(personTypeViewController)
    }
    
    func toRelationshipStatus(profile: Profile) {
        let relationshipStatusViewController = factory.makeOnboardingRelationshipStatusViewController(coordinator: self,
                                                                                                      profile: profile)
        rootViewController.setContentViewController(relationshipStatusViewController)
    }
    
    func toBirthday(profile: Profile) {
        let birthdayViewController = factory.makeOnboardingBirthdayViewController(coordinator: self,
                                                                                  profile: profile)
        rootViewController.setContentViewController(birthdayViewController)
    }
    
    func toAnniversary(profile: Profile) {
        let anniversaryViewController = factory.makeOnboardingAnniversaryViewController(coordinator: self,
                                                                                        profile: profile,
                                                                                        useCaseProvider: self.useCaseProvider)
        rootViewController.setContentViewController(anniversaryViewController)
    }
}

// MARK: - CoordinatorDelegate

extension PreOnboardingCoordinator: CoordinatorDelegate {
    func didFinish(coordinator: AnyCoordinator) {
        removeDependency(coordinator)
    }
}
