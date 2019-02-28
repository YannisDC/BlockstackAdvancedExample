//
//  LikeItemViewModel.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 21/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core

final class LikeItemViewModel   {
    let title:String
    let like: Like
    let image: UIImage?
    let tags: [String]
    
    init (with like:Like) {
        self.like = like
        self.title = like.description?.capitalized ?? ""
        self.image = like.image
        self.tags = like.tags
    }
}
