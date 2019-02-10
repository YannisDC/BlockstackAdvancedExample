//
//  BaseDatePickerViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 10/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// MARK: - ViewModel

class BaseDatePickerViewModel: ViewModel {
    func transform(input: Input) -> Output {
        fatalError("Implement me")
    }
    
    struct Input {
        let selection: Driver<Date>
        let continueTrigger: Driver<Void>
    }
    
    struct Output {
        let title: Driver<String>
        let continueButtonTitle: Driver<String>
        let continueResult: Driver<Void>
    }
}
