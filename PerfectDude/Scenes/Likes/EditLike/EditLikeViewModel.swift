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
    private let likeUsecase: LikesUseCase!
    fileprivate let imagesTrigger: PublishSubject<UIImage?>
    private let like: Like
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<LikesRoute>?,
         usecaseProvider: Core.UseCaseProvider,
         imagesTrigger: PublishSubject<UIImage?>,
         like: Like) {
        self.coordinator = coordinator
        self.likeUsecase = usecaseProvider.makeLikesUseCase()
        self.imagesTrigger = imagesTrigger
        self.like = like
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
        
        let encryption = Driver.merge(input.encryption,
                                      Driver.just(like.encrypted))
        
        let titleAndImage = Driver.combineLatest(input.title,
                                                 imageToSave,
                                                 encryption)
                                                    { (like, titleAndImage, encryption) in
                                                        return (like, titleAndImage, encryption)
                                                    }
        
        let likeToSave = Driver.combineLatest(Driver.just(self.like),
                                              input.title,
                                              encryption)
                                                { (like, title, encryption) -> Like in
                                                    return Like(description: title,
                                                                image: like.image,
                                                                tags: [],
                                                                uuid: like.uuid,
                                                                encrypted: encryption)
                                                }
                                                .startWith(self.like)
        
        let editButtonTitle = editing.map { editing -> String in
            return editing == true ? "Save" : "Edit"
        }
        
        let saveLike = saveTrigger.withLatestFrom(likeToSave)
            .flatMapLatest { [unowned self] in
                return self.likeUsecase.save(like: $0)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .flatMap({ (_) -> Driver<Void> in
                        return Driver.just(())
                    })
        }
        
        let deleteLike = input.deleteTrigger
            .withLatestFrom(likeToSave)
            .flatMapLatest { newLike in
                return self.likeUsecase.delete(like: newLike)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .mapToVoid()
            }
        
        let dismiss = Driver.of(saveLike, deleteLike)
            .merge().do(onNext: {
                self.coordinator?.coordinate(to: .overview)
            })
        
        return Output(editButtonTitle: editButtonTitle,
                      dismiss: dismiss,
                      save: saveLike,
                      delete: deleteLike,
                      editing: editing,
                      like: likeToSave,
                      error: errorTracker.asDriver(),
                      encryption: encryption)
    }
}

// MARK: - ViewModel

extension EditLikeViewModel {
    struct Input {
        let editTrigger: Driver<Void>
        let deleteTrigger: Driver<Void>
        let title: Driver<String>
        let selectImageTrigger: Driver<Void>
        let encryption: Driver<Bool>
    }
    
    struct Output {
        let editButtonTitle: Driver<String>
        let dismiss: Driver<Void>
        let save: Driver<Void>
        let delete: Driver<Void>
        let editing: Driver<Bool>
        let like: Driver<Like>
        let error: Driver<Error>
        let encryption: Driver<Bool>
    }
}
