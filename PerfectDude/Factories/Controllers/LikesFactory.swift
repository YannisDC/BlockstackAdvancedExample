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
    ///   - useCaseProvider: Core.UseCaseProvider instance
    /// - Returns: LikesViewController instance
    func makeLikesViewController(coordinator: BaseCoordinator<LikesRoute>,
                                 useCaseProvider: Core.UseCaseProvider) -> LikesViewController
    
    /// Creates a CreateLikeViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<LikesRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    ///   - imagesTrigger: PublishSubject<UIImage?> instance
    /// - Returns: CreateLikeViewController instance
    func makeCreateLikeViewController(coordinator: BaseCoordinator<LikesRoute>,
                                      useCaseProvider: Core.UseCaseProvider,
                                      imagesTrigger: PublishSubject<UIImage?>) -> CreateLikeViewController
    
    /// Creates an EditLikeViewController
    ///
    /// - Parameters:
    ///   - coordinator: BaseCoordinator<LikesRoute> instance
    ///   - useCaseProvider: Core.UseCaseProvider instance
    ///   - imagesTrigger: PublishSubject<UIImage?> instance
    ///   - like: Like instance
    /// - Returns: EditLikeViewController instance
    func makeEditLikeViewController(coordinator: BaseCoordinator<LikesRoute>,
                                    useCaseProvider: Core.UseCaseProvider,
                                    imagesTrigger: PublishSubject<UIImage?>,
                                    like: Like) -> CreateLikeViewController
}
