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
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<HomeRoute>?,
         useCaseProvider: Core.UseCaseProvider) {
        self.coordinator = coordinator
        self.initUsecase = useCaseProvider.makeInitUseCase()
    }
    
    // MARK: Transform
    
    func transform(input: HomeViewModel.Input) -> HomeViewModel.Output {
        let title = Driver.just("Home".localized())
        
        let signOutResult = input.signOutTap.do(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.coordinator?.coordinate(to: .signOut)
        })
        
        let showResult = input.showTap.do(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.initUsecase.initPublishPublicKey().subscribe()
            self.initUsecase.initLikeIndexes().subscribe()
            self.initUsecase.initCalendarEventIndexes().subscribe()
        })
        
        return Output(signOutResult: signOutResult,
                      showResult: showResult,
                      title: title)
    }
}

// MARK: - ViewModel

extension HomeViewModel {
    struct Input {
        let signOutTap: Driver<Void>
        let showTap: Driver<Void>
    }
    
    struct Output {
        let signOutResult: Driver<Void>
        let showResult: Driver<Void>
        let title: Driver<String>
    }
}
