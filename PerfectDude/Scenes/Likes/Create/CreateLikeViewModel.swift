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
import TagListView

final class CreateLikeViewModel: LikeViewModel {

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

    override func transform(input: Input) -> Output {
        let title = Driver.just("Create".localized())
        
        let editButtonTitle = Driver<String>.just("save".localized())
        
        // MARK: Activity and Error tracking
        let activityIndicator = ActivityIndicator()
        let fetching = activityIndicator.asDriver()
        let errorTracker = ErrorTracker()
        let errors = errorTracker.asDriver()
        
        // MARK: View states
        let isEditing = Driver<Bool>.just(true)
        let isUpdating = Driver<Bool>.just(false)
        
        let canSave = Driver
            .combineLatest(input.likeTitle, activityIndicator.asDriver()) {
                return !$0.isEmpty && !$1
            }
        
        
        // MARK: Like fields
        let encryption = input.encryption
        
        let imageToSave = imagesTrigger.asDriver(onErrorJustReturn: nil)
        
        let tagsAndNew = Driver.combineLatest(input.newTagTitle, input.tags)
        
        let newTagsAndTitle = input.newTagTrigger
            .withLatestFrom(tagsAndNew)
            .filter({ !$0.0.isEmpty })
            .map { (title, list) -> (String, [TagView]) in
                var newList = list
                newList.append(TagView(title: title))
                return ("", newList)
            }
        
        let tags = newTagsAndTitle
            .map { $0.1 }
//            .startWith([TagView(title: "Gift")])
        
        let newTagTitle = newTagsAndTitle.map { $0.0 }
        
        let newTagTrigger = newTagsAndTitle.mapToVoid()
        
        let titleAndImage = Driver.combineLatest(input.likeTitle,
                                                 imageToSave,
                                                 input.encryption)
        
        // MARK: Actions
        let save = input.editTrigger.withLatestFrom(titleAndImage)
            .map { (title, image, encryption) in
//                let likeTags = tags.map {$0.title(for: UIControl.State()) ?? ""}
                return Like(description: title, image: image, tags: [""], encrypted: encryption)
            }
            .flatMapLatest { [unowned self] in
                return self.likeUsecase.save(like: $0)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                    .flatMap({ (_) -> Driver<Void> in
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
        
        let tagDeleteResult = input.tagDeleteTrigger
//            .do(onNext: { (tag, list) in
//                list.removeTagView(tag)
//            })

        return Output(title: title,
                      editButtonTitle: editButtonTitle,
                      dismiss: dismiss,
                      save: save,
                      delete: Driver<Void>.just(()),
                      isEditing: isEditing,
                      isUpdating: isUpdating,
                      imageToSave: imageToSave,
                      likeTitle: Driver<String>.just(""),
                      saveEnabled: canSave,
                      selectImage: selectImage,
                      tags: tags,
                      tagDeleteResult: tagDeleteResult,
                      newTagTitle: newTagTitle,
                      newTagTrigger: newTagTrigger,
                      encryption: encryption,
                      fetching: fetching,
                      error: errors)
    }
}
