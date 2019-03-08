//
//  HomeViewModel.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Core

final class HomeViewModel: ViewModel {
    
    private weak var coordinator: BaseCoordinator<HomeRoute>?
    private var initUsecase: InitUseCase!
    private var profileUsecase: ProfileUseCase!
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<HomeRoute>?,
         useCaseProvider: Core.UseCaseProvider) {
        self.coordinator = coordinator
        self.initUsecase = useCaseProvider.makeInitUseCase()
        self.profileUsecase = useCaseProvider.makeProfileUseCase()
    }
    
    // MARK: Transform
    
    func transform(input: HomeViewModel.Input) -> HomeViewModel.Output {
        let title = Driver.just("settings".localized())
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let editing = input.editTrigger
            .scan(false) { editing, _ in
                return !editing
            }
            .startWith(false)
        
        let saveTrigger = editing
            .skip(1) //we dont need initial state
            .filter { $0 == false }
            .mapToVoid()
        
        let signOutResult = input.signOutTap.do(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.coordinator?.coordinate(to: .signOut)
        })
        
        let showResult = input.showTap.do(onNext: { [weak self] _ in
            guard let `self` = self else { return }
//            self.initUsecase.initPublishPublicKey().subscribe()
//            self.initUsecase.initLikeIndexes().subscribe()
//            self.initUsecase.initCalendarEventIndexes().subscribe()
        })
        
        let profile = input.trigger
            .flatMapLatest { _ in
                return self.profileUsecase
                    .getProfile()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let notificationsToggle = Driver.merge(profile.map { $0.reminders.notifications }, input.notificationsToggle)
        let birthdayToggle = Driver.merge(profile.map { $0.reminders.birthdayReminder }, input.birthdayToggle)
        let anniversaryToggle = Driver.merge(profile.map { $0.reminders.anniversaryReminder }, input.anniversaryToggle)
        let marriageToggle = Driver.merge(profile.map { $0.reminders.marriageReminder }, input.marriageToggle)
        let flowerToggle = Driver.merge(profile.map { $0.reminders.flowersReminder }, input.flowerToggle)
        let surpriseToggle = Driver.merge(profile.map { $0.reminders.surprisesReminder }, input.surpriseToggle)
        
        let editButtonTitle = editing.map { editing -> String in
            return editing == true ? "save".localized() : "edit".localized()
        }
        
        let profileToSave = Driver.combineLatest(profile,
                                                 notificationsToggle,
                                                 birthdayToggle,
                                                 anniversaryToggle,
                                                 marriageToggle,
                                                 flowerToggle,
                                                 surpriseToggle)
        { oldProfile, notifications, birthday, anniversary, marriage, flower, surprise -> Profile in
            var newProfile = oldProfile
            newProfile.reminders.notifications = notifications
            newProfile.reminders.birthdayReminder = birthday
            newProfile.reminders.anniversaryReminder = anniversary
            newProfile.reminders.marriageReminder = marriage
            newProfile.reminders.flowersReminder = flower
            newProfile.reminders.surprisesReminder = surprise
            return newProfile
        }
        
        let saveProfile = saveTrigger
            .withLatestFrom(profileToSave)
            .flatMapLatest { [unowned self] in
                return self.profileUsecase
                    .saveProfile(profile: $0)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .flatMap({ (_) -> Driver<Void> in
                        return Driver.just(())
                    })
        }
        
        
        return Output(editButtonTitle: editButtonTitle,
                      editing: editing,
                      save: saveProfile,
                      signOutResult: signOutResult,
                      showResult: showResult,
                      title: title,
                      profile: profile,
                      notificationsToggle: notificationsToggle,
                      birthdayToggle: birthdayToggle,
                      anniversaryToggle: anniversaryToggle,
                      marriageToggle: marriageToggle,
                      flowerToggle: flowerToggle,
                      surpriseToggle: surpriseToggle)
    }
}

// MARK: - ViewModel

extension HomeViewModel {
    struct Input {
        let trigger: Driver<Void>
        let editTrigger: Driver<Void>
        let signOutTap: Driver<Void>
        let personType: Driver<Int>
        let relationshipType: Driver<Int>
        let notificationsToggle: Driver<Bool>
        let birthdayToggle: Driver<Bool>
        let anniversaryToggle: Driver<Bool>
        let marriageToggle: Driver<Bool>
        let flowerToggle: Driver<Bool>
        let surpriseToggle: Driver<Bool>
        let showTap: Driver<Void>
    }
    
    struct Output {
        let editButtonTitle: Driver<String>
        let editing: Driver<Bool>
        let save: Driver<Void>
        let signOutResult: Driver<Void>
        let showResult: Driver<Void>
        let title: Driver<String>
        let profile: Driver<Profile>
        let notificationsToggle: Driver<Bool>
        let birthdayToggle: Driver<Bool>
        let anniversaryToggle: Driver<Bool>
        let marriageToggle: Driver<Bool>
        let flowerToggle: Driver<Bool>
        let surpriseToggle: Driver<Bool>
    }
}
