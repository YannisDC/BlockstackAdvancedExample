//
//  InitialiseUseCase.swift
//  Core
//
//  Created by Yannis De Cleene on 19/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import RxSwift

public protocol InitUseCase {

    func initLikeIndexes() -> Single<String?>
    
}
