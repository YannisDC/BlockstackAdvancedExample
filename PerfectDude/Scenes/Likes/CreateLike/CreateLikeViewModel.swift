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
    // TODO: inject useCaseProvider
    private var likeUsecase = UseCaseProvider().blockstackUseCaseProvider.makeLikesUseCase()
    fileprivate let imagesTrigger: PublishSubject<UIImage?>
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<LikesRoute>?,
         imagesTrigger: PublishSubject<UIImage?>) {
        self.coordinator = coordinator
        self.imagesTrigger = imagesTrigger
    }

    // MARK: Transform

    func transform(input: CreateLikeViewModel.Input) -> CreateLikeViewModel.Output {
        
        let title = input.title
        let activityIndicator = ActivityIndicator()
        
        let imageToSave = imagesTrigger.asDriver(onErrorJustReturn: nil)
        
        let titleAndImage = Driver.combineLatest(input.title, imageToSave)
        
        let canSave = Driver.combineLatest(title, activityIndicator.asDriver()) {
            return !$0.isEmpty && !$1
        }
        
        let save = input.saveTrigger.withLatestFrom(titleAndImage)
            .map { (title, image) in
                return Like(description: title, image: image, tags: [""])
            }
            .flatMapLatest { [unowned self] in
                return self.likeUsecase.create(like: $0)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete().flatMap({ (_) -> Driver<Void> in
                        return Driver.just(())
                    })
        }
        
        let dismiss = Driver.of(save, input.cancelTrigger)
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
                      selectImage: selectImage)
    }
}

// MARK: - ViewModel

extension CreateLikeViewModel {
    struct Input {
        let cancelTrigger: Driver<Void>
        let saveTrigger: Driver<Void>
        let selectImageTrigger: Driver<Void>
        let title: Driver<String>
    }

    struct Output {
        let title: Driver<String>
        let imageToSave: Driver<UIImage?>
        let dismiss: Driver<Void>
        let saveEnabled: Driver<Bool>
        let selectImage: Driver<Void>
    }
}
