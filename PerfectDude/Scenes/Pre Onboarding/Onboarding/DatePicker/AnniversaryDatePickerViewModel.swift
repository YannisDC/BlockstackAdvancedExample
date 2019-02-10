//
//  AnniversaryDatePickerViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 10/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa

final class AnniversaryDatePickerViewModel: BaseDatePickerViewModel {
    
    private weak var coordinator: BaseCoordinator<PreOnboardingRoute>?
    private let profile: Profile
    private let profileUseCase: ProfileUseCase
    private let calendarEventsUsecase: CalendarEventsUseCase!
    private let initUseCase: InitUseCase
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<PreOnboardingRoute>?,
         profile: Profile,
         useCaseProvider: Core.UseCaseProvider) {
        self.coordinator = coordinator
        self.profile = profile
        self.profileUseCase = useCaseProvider.makeProfileUseCase()
        self.calendarEventsUsecase = useCaseProvider.makeCalendarEventsUseCase()
        self.initUseCase = useCaseProvider.makeInitUseCase()
    }
    
    // MARK: Transform
    
    override func transform(input: Input) -> Output {
        let title = Driver.just("When did you get together with her?".localized())
        
        let continueButtonTitle = Driver.just("".localized())
        
        let continueResult = input.continueTrigger
            .withLatestFrom(input.selection)
            .flatMap({ [weak self] (date) -> Driver<Void> in
                guard let `self` = self else { return Driver.empty() }
                
                var profile = self.profile
                profile.anniversary = date
                
                return self.profileUseCase
                    .saveProfile(profile: profile)
                    .andThen(self.publiskPublicKey())
                    .andThen(self.initLikeIndex())
                    .andThen(self.initEventIndex())
                    .andThen(self.saveBirthday(profile: profile))
                    .andThen(self.saveAnniversary(profile: profile))
                    .do(onCompleted: {
                        self.coordinator?.coordinate(to: .finished)
                    })
                    .asDriver(onErrorDriveWith: .empty())
                    .mapToVoid()
            })
        
        return Output(title: title,
                      continueButtonTitle: continueButtonTitle,
                      continueResult: continueResult,
                      disableTrigger: input.continueTrigger)
    }
}

extension AnniversaryDatePickerViewModel {
    private func saveBirthday(profile: Profile) -> Completable {
        return Completable.create { completable in
            self.calendarEventsUsecase
                .save(event: CalendarEvent(eventType: .special,
                                           name: "Birthday",
                                           description: "Make her feel like a queen.",
                                           date: profile.birthday,
                                           location: ""))
                .subscribe(onSuccess: { (profile) in
                    completable(.completed)
                }, onError: { (error) in
                    completable(.error(error))
                })
            return Disposables.create {}
        }
    }
    
    private func saveAnniversary(profile: Profile) -> Completable {
        return Completable.create { completable in
            self.calendarEventsUsecase
                .save(event: CalendarEvent(eventType: .special,
                                           name: "Anniversary",
                                           description: "You better remember this one.",
                                           date: profile.anniversary,
                                           location: ""))
                .subscribe(onSuccess: { (profile) in
                    completable(.completed)
                }, onError: { (error) in
                    completable(.error(error))
                })
            return Disposables.create {}
        }
    }
    
    private func publiskPublicKey() -> Completable {
        return Completable.create { completable in
            self.initUseCase
                .initPublishPublicKey()
                .subscribe(onSuccess: { (profile) in
                    completable(.completed)
                }, onError: { (error) in
                    completable(.error(error))
                })
            return Disposables.create {}
        }
    }
    
    private func initLikeIndex() -> Completable {
        return Completable.create { completable in
            self.initUseCase
                .initLikeIndexes()
                .subscribe(onSuccess: { (profile) in
                    completable(.completed)
                }, onError: { (error) in
                    completable(.error(error))
                })
            return Disposables.create {}
        }
    }
    
    private func initEventIndex() -> Completable {
        return Completable.create { completable in
            self.initUseCase
                .initCalendarEventIndexes()
                .subscribe(onSuccess: { (profile) in
                    completable(.completed)
                }, onError: { (error) in
                    completable(.error(error))
                })
            return Disposables.create {}
        }
    }
}
