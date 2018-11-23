//
//  LikesRoute.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 20/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core

enum LikesRoute: Route {
    case overview
    case likes
    case create
    case edit(_ like: Like)
    case selectImage
}
