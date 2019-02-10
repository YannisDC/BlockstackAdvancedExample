//
//  ProfileUseCase.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 09/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import RxSwift

public protocol ProfileUseCase {
    
    func getProfile() -> Single<Profile>
    func saveProfile(profile: Profile) -> Completable
    
}
