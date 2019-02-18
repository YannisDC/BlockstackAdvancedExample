//
//  CreateLikeViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 21/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa

final class CreateLikeViewModel: ViewModel {

    private weak var coordinator: BaseCoordinator<LikesRoute>?
    private let likeUsecase: LikesUseCase!
    fileprivate let imagesTrigger: PublishSubject<UIImage?>
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<LikesRoute>?,
         useCaseProvider: Core.UseCaseProvider,
         imagesTrigger: PublishSubject<UIImage?>) {
        self.coordinator = coordinator
        self.likeUsecase = useCaseProvider.makeLikesUseCase()
        self.imagesTrigger = imagesTrigger
    }

    // MARK: Transform

    func transform(input: CreateLikeViewModel.Input) -> CreateLikeViewModel.Output {
        let title = Driver.just("Create".localized())
        
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        
        let imageToSave = imagesTrigger.asDriver(onErrorJustReturn: nil)
        
        let titleAndImage = Driver.combineLatest(input.likeTitle, imageToSave, input.encryption)
        
        let canSave = Driver.combineLatest(input.likeTitle, activityIndicator.asDriver()) {
            return !$0.isEmpty && !$1
        }
        
        let save = input.saveTrigger.withLatestFrom(titleAndImage)
            .map { (title, image, encryption) in
                return Like(description: title, image: image, tags: [""], encrypted: encryption)
            }
            .flatMapLatest { [unowned self] in
                return self.likeUsecase.save(like: $0)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete().flatMap({ (_) -> Driver<Void> in
                        return Driver.just(())
                    })
            }
        
        let dismiss = Driver.of(save)
            .merge().do(onNext: {
                self.coordinator?.coordinate(to: .overview)
            })
        
        let selectImage = input.selectImageTrigger.do(onNext: {
            self.coordinator?.coordinate(to: .selectImage)
        })

        return Output(title: title,
                      imageToSave: imageToSave,
                      dismiss: dismiss,
                      saveEnabled: canSave,
                      selectImage: selectImage,
                      fetching: fetching,
                      error: errors)
    }
}

// MARK: - ViewModel

extension CreateLikeViewModel {
    struct Input {
        let saveTrigger: Driver<Void>
        let selectImageTrigger: Driver<Void>
        let likeTitle: Driver<String>
        let encryption: Driver<Bool>
    }

    struct Output {
        let title: Driver<String>
        let imageToSave: Driver<UIImage?>
        let dismiss: Driver<Void>
        let saveEnabled: Driver<Bool>
        let selectImage: Driver<Void>
        let fetching: Driver<Bool>
        let error: Driver<Error>
    }
}
