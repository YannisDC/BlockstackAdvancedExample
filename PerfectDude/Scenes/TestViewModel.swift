//
//  TestViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 04/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TestViewModel: ViewModel {

    private weak var coordinator: BaseCoordinator<TestRoute>?

    // MARK: Init

    init(coordinator: BaseCoordinator<TestRoute>?) {
        self.coordinator = coordinator
    }

    // MARK: Transform

    func transform(input: TestViewModel.Input) -> TestViewModel.Output {
        let title = Driver.just("".localized())

        return Output(title: title)
    }
}

// MARK: - ViewModel

extension TestViewModel {
    struct Input {
    }

    struct Output {
        let title: Driver<String>
    }
}
