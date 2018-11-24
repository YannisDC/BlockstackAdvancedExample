//
//  EditLikeViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 21/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa

final class EditLikeViewModel: ViewModel {

    private weak var coordinator: BaseCoordinator<LikesRoute>?
    // TODO: inject useCaseProvider
    private var likeUsecase = UseCaseProvider().blockstackUseCaseProvider.makeLikesUseCase()
    private let like: Like
    fileprivate let imagesTrigger: PublishSubject<UIImage?>
    
    // MARK: Init

    init(coordinator: BaseCoordinator<LikesRoute>?,
         like: Like,
         imagesTrigger: PublishSubject<UIImage?>) {
        self.coordinator = coordinator
        self.like = like
        self.imagesTrigger = imagesTrigger
    }

    // MARK: Transform
    
    func transform(input: EditLikeViewModel.Input) -> EditLikeViewModel.Output {
        let errorTracker = ErrorTracker()
        let editing = input.editTrigger.scan(false) { editing, _ in
            return !editing
        }.startWith(false)
        
        let saveTrigger = editing.skip(1) //we dont need initial state
            .filter { $0 == false }
            .mapToVoid()
        
        let imageToSave = imagesTrigger.asDriver(onErrorJustReturn: nil)
        
        let titleAndImage = Driver.combineLatest(input.title, imageToSave) { (like, titleAndImage) in
            return (like, titleAndImage)
        }
        
        let likeToSave = Driver.combineLatest(Driver.just(self.like), input.title) { (like, title) -> Like in
                return Like(description: title, image: like.image, tags: [], uuid: like.uuid)
            }
            .startWith(self.like)
        
        let editButtonTitle = editing.map { editing -> String in
            return editing == true ? "Save" : "Edit"
        }
        
        let saveLike = saveTrigger.withLatestFrom(likeToSave)
            .flatMapLatest { like in
                return self.likeUsecase.update(like: like)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .mapToVoid()
        }
        
        let deleteLike = input.deleteTrigger
            .withLatestFrom(likeToSave)
            .flatMapLatest { newLike in
                return self.likeUsecase.delete(like: newLike)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .mapToVoid()
            }
        
        let dismiss = Driver.of(saveLike, input.cancelTrigger, deleteLike)
            .merge().do(onNext: {
                self.coordinator?.coordinate(to: .overview)
            })
        
        return Output(editButtonTitle: editButtonTitle,
                      dismiss: dismiss,
                      save: saveLike,
                      delete: deleteLike,
                      editing: editing,
                      like: likeToSave,
                      error: errorTracker.asDriver())
    }
}

// MARK: - ViewModel

extension EditLikeViewModel {
    struct Input {
        let cancelTrigger: Driver<Void>
        let editTrigger: Driver<Void>
        let deleteTrigger: Driver<Void>
        let title: Driver<String>
        let selectImageTrigger: Driver<Void>
    }
    
    struct Output {
        let editButtonTitle: Driver<String>
        let dismiss: Driver<Void>
        let save: Driver<Void>
        let delete: Driver<Void>
        let editing: Driver<Bool>
        let like: Driver<Like>
        let error: Driver<Error>
    }
}
