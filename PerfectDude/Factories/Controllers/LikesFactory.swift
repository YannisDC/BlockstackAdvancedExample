//
//  LikesFactory.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 20/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift

protocol LikesFactory {
    /// Creates a LikesViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<LikesRoute> instance
    /// - Returns: LikesViewController
    func makeLikesViewController(coordinator: BaseCoordinator<LikesRoute>) -> LikesViewController
    
    func makeCreateLikeViewController(coordinator: BaseCoordinator<LikesRoute>,
                                      imagesTrigger: PublishSubject<UIImage?>) -> CreateLikeViewController
    
    func makeEditLikeViewController(coordinator: BaseCoordinator<LikesRoute>,
                                    imagesTrigger: PublishSubject<UIImage?>,
                                    like: Like) -> EditLikeViewController
}
