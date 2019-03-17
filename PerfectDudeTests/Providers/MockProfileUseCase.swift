//
//  MockProfileUseCase.swift
//  PerfectDudeTests
//
//  Created by Yannis De Cleene on 17/03/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import XCTest
@testable import PerfectDude
@testable import Core
import RxSwift

final class MockProfileUseCase: Core.ProfileUseCase {
    func getProfile() -> Single<Profile> {
        return Single<Profile>.create { single in
            single(.success(Profile(personType: .donJuan,
                                    maritialStatus: .relationship,
                                    birthday: Date(),
                                    anniversary: Date(),
                                    reminders: Reminders())))
            return Disposables.create()
        }
    }
    
    func saveProfile(profile: Profile) -> Completable {
        return Completable.create { completable in
            completable(.completed)
            return Disposables.create {}
        }
    }
}
