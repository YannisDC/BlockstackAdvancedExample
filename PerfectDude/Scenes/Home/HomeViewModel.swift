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
    private var likeUsecase = UseCaseProvider().blockstackUseCaseProvider.makeLikesUseCase()
    private var initUsecase = UseCaseProvider().blockstackUseCaseProvider.makeInitUseCase()
    fileprivate let imagesTrigger: PublishSubject<UIImage?>
    
    fileprivate var likes = Variable<[Like?]>([])
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<HomeRoute>?,
         imagesTrigger: PublishSubject<UIImage?>) {
        self.coordinator = coordinator
        self.imagesTrigger = imagesTrigger
    }
    
    // MARK: Transform
    
    func transform(input: HomeViewModel.Input) -> HomeViewModel.Output {
        let title = Driver.just("onboarding_set_your_pin_title".localized())
        
        let signOutResult = input.signOutTap.do(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.coordinator?.coordinate(to: .signOut)
        })
        
        let showResult = input.showTap.do(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.initUsecase.initLikeIndexes()
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
