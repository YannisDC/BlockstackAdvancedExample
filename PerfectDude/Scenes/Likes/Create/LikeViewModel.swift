//
//  LikeViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 28/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa
import TagListView

class LikeViewModel: ViewModel {
    
    func transform(input: Input) -> Output {
        fatalError("Implement me")
    }
    
    struct Input {
        let editTrigger: Driver<Void>
        let deleteTrigger: Driver<Void>
        let selectImageTrigger: Driver<Void>
        let likeTitle: Driver<String>
        let tags: Driver<[TagView]>
        let encryption: Driver<Bool>
        let tagDeleteTrigger: Driver<(TagView, TagListView)>
        let newTagTitle: Driver<String>
        let newTagTrigger: Driver<Void>
    }
    
    struct Output {
        let title: Driver<String>
        
        let editButtonTitle: Driver<String>
        let dismiss: Driver<Void>
        let save: Driver<Void>
        let delete: Driver<Void>
        let isEditing: Driver<Bool>
        let isUpdating: Driver<Bool>
        
        let imageToSave: Driver<UIImage?>
        let saveEnabled: Driver<Bool>
        let selectImage: Driver<Void>
        
        let tags: Driver<[TagView]>
        let tagDeleteResult: Driver<(TagView, TagListView)>
        let newTagTitle: Driver<String>
        let newTagTrigger: Driver<Void>
        
        let encryption: Driver<Bool>
        
        let fetching: Driver<Bool>
        let error: Driver<Error>
    }
}
