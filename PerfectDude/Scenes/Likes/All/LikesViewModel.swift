//
//  LikesViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 21/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa

final class LikesViewModel: ViewModel {

    private weak var coordinator: BaseCoordinator<LikesRoute>?
    private let likeUsecase: LikesUseCase!

    // MARK: Init

    init(coordinator: BaseCoordinator<LikesRoute>?,
         useCaseProvider: Core.UseCaseProvider) {
        self.coordinator = coordinator
        self.likeUsecase = useCaseProvider.makeLikesUseCase()
    }

    // MARK: Transform

    func transform(input: LikesViewModel.Input) -> LikesViewModel.Output {
        
        let title = Driver.just("likes".localized())
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let likes = input.trigger
            .flatMapLatest { _ in
                return self.likeUsecase.queryAll()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .map { $0.map { LikeItemViewModel(with: $0) }.sorted(by: { $0.title < $1.title }) }
            }
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        let selectedLike = input.selection
            .withLatestFrom(likes) { (indexPath, likes) -> Like in
                return likes[indexPath.row].like
            }.do(onNext: { like in
                self.coordinator?.coordinate(to: .edit(like))
            })
        
        let createLike = input.createLikeTrigger.do(onNext: {
            self.coordinator?.coordinate(to: .create)
        })

        return Output(title: title,
                      fetching: fetching,
                      likes: likes,
                      createLike: createLike,
                      selectedLike: selectedLike,
                      error: errors)
    }
}

// MARK: - ViewModel

extension LikesViewModel {
    struct Input {
        let trigger: Driver<Void>
        let createLikeTrigger: Driver<Void>
        let selection: Driver<IndexPath>
    }

    struct Output {
        let title: Driver<String>
        let fetching: Driver<Bool>
        let likes: Driver<[LikeItemViewModel]>
        let createLike: Driver<Void>
        let selectedLike: Driver<Like>
        let error: Driver<Error>
    }
}
