//
//  UseCaseProvider.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 05/11/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import Core
import RxSwift
import BlockstackPlatform

final class UseCaseProvider {
    
    public let blockstackUseCaseProvider: Core.UseCaseProvider
    
    init() {
        blockstackUseCaseProvider = BlockstackPlatform.UseCaseProvider()
    }
    
}
