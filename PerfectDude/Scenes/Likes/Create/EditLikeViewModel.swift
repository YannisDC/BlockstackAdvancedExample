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
import TagListView

final class EditLikeViewModel: LikeViewModel {

    private weak var coordinator: BaseCoordinator<LikesRoute>?
    private let likeUsecase: LikesUseCase!
    fileprivate let imagesTrigger: PublishSubject<UIImage?>
    private let like: Like
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<LikesRoute>?,
         useCaseProvider: Core.UseCaseProvider,
         imagesTrigger: PublishSubject<UIImage?>,
         like: Like) {
        self.coordinator = coordinator
        self.likeUsecase = useCaseProvider.makeLikesUseCase()
        self.imagesTrigger = imagesTrigger
        self.like = like
    }

    // MARK: Transform
    
    override func transform(input: Input) -> Output {
        let title = Driver.just("edit".localized())
        
        // MARK: Activity and Error tracking
        let activityIndicator = ActivityIndicator()
        let fetching = activityIndicator.asDriver()
        let errorTracker = ErrorTracker()
        let errors = errorTracker.asDriver()
        
        // MARK: View states
        let isEditing = input.editTrigger
            .scan(false) { isEditing, _ in
                return !isEditing
            }
            .startWith(false)
        
        let isUpdating = Driver<Bool>.just(true)
        
        // MARK: Actions
        
        
        let imageToSave = imagesTrigger.asDriver(onErrorJustReturn: nil)
        
        let encryption = Driver.merge(input.encryption,
                                      Driver.just(like.encrypted))
        
        let description = Driver.merge(input.likeTitle,
                                       Driver.just(like.description)).do(onNext: { (title) in
                                        print(title)
                                       })
        
        let oldTags = Driver<Like>.just(like)
            .map { (like) -> [TagView] in
                print(like)
                return like.tags
                    .filter { $0 != "" }
                    .map { TagView(title: $0) }
            }
        
        let newTag = input.newTagTrigger
            .withLatestFrom(input.newTagTitle)
            .filter({ !$0.isEmpty })
            .map { TagView(title: $0) }
            .do(onNext: { (_) in
                print("New tag added")
            })
        
        let deleteTag = input.tagDeleteTrigger
            .do(onNext: { (_) in
                print("Tag deleted")
            })
        
        let allTags = Driver
            .combineLatest(oldTags, newTag)
            .map { (old, new) -> [TagView] in
                var newList = old + [new]
                newList.removeDuplicates()
                print(newList)
                return newList//.filter { $0 != delete }
            }
        
        let allTagsAsStrings = allTags.map { (tagList) -> [String] in
            let fullList = tagList.map { $0.title(for: UIControl.State()) ?? "" }
            return fullList
        }
        
        let likeToSave = Driver
            .combineLatest(Driver.just(like), description, allTagsAsStrings, encryption)
            .map { (like, title, tagStringList, encryption) -> Like in
                print(title)
                return Like(description: title,
                            image: like.image,
                            tags: tagStringList,
                            uuid: like.uuid,
                            encrypted: encryption)
            }
            .startWith(like)
        
        let editButtonTitle = isEditing
            .map { isEditing -> String in
                return isEditing == true ? "save".localized() : "edit".localized()
            }
        
        let saveLike = Driver.combineLatest(isEditing.skip(1).filter { $0 == false }, likeToSave, description)
            .flatMapLatest { [weak self] (isEditing, like, description) -> Driver<Void> in
                guard let `self` = self else {
                    return Driver.just(())
                }
                
                let newLike = Like(description: description,
                                   image: like.image,
                                   tags: like.tags,
                                   uuid: like.uuid,
                                   encrypted: like.encrypted)
                
                return self.likeUsecase.save(like: newLike)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                    .flatMap({ (_) -> Driver<Void> in
                        return Driver.just(())
                    })
        }
        
        let deleteLike = input.deleteTrigger
            .flatMapLatest { [weak self] newLike -> Driver<Void> in
                guard let `self` = self else {
                    return Driver.just(())
                }
                return self.likeUsecase.delete(like: self.like)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                    .mapToVoid()
            }
        
        let dismiss = Driver.of(saveLike, deleteLike)
            .merge()
            .do(onNext: { [weak self] (_) -> Void in
                guard let `self` = self else {
                    return ()
                }
                self.coordinator?.coordinate(to: .overview)
            })
        
        let likeImage = Driver.merge(likeToSave.map { $0.image },
                                     imageToSave)
        
        return Output(title: title,
                      editButtonTitle: editButtonTitle,
                      dismiss: dismiss,
                      save: saveLike,
                      delete: deleteLike,
                      isEditing: isEditing,
                      isUpdating: isUpdating,
                      imageToSave: likeImage,
                      likeTitle: description,
                      saveEnabled: Driver<Bool>.just(true),
                      selectImage: input.selectImageTrigger,
                      tags: allTags,
                      tagDeleteResult: deleteTag,
                      newTagTitle: input.newTagTitle,
                      newTagTrigger: input.newTagTrigger,
                      encryption: encryption,
                      fetching: fetching,
                      error: errors)
    }
}
