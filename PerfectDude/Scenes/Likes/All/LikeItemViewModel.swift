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
    
    init (with like:Like) {
        self.like = like
        self.title = like.description?.uppercased() ?? "Not found"
        self.image = like.image
    }
}