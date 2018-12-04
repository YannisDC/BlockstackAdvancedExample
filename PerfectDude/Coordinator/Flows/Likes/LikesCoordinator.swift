//
//  LikesCoordinator.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 20/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation
import Core
import RxSwift
import Gallery

final class LikesCoordinator: BaseCoordinator<LikesRoute> {
    
    fileprivate weak var rootViewController: BaseViewController!
    fileprivate weak var delegate: CoordinatorDelegate?
    fileprivate let factory: LikesFactory
    fileprivate let usecaseProvider: Core.UseCaseProvider
    fileprivate let imagesTrigger = PublishSubject<UIImage?>()
    fileprivate let navigationController: NavigationController!
    fileprivate var modalNavigationController = ModalNavigationController()
    
    // MARK: Init
    
    init(rootViewController: BaseViewController,
         delegate: CoordinatorDelegate?,
         factory: ControllerFactory,
         usecaseProvider: Core.UseCaseProvider) {
        self.rootViewController = rootViewController
        self.delegate = delegate
        self.factory = factory
        self.usecaseProvider = usecaseProvider
        self.navigationController = NavigationController()
    }
    
    
    // MARK: Coordinator
    
    override func start() {
        coordinate(to: .overview)
    }
    
    override func coordinate(to route: LikesRoute) {
        DispatchQueue.main.async {
            switch route {
            case .overview:
                self.toOverview()
            case .likes:
                self.toLikes()
            case .create:
                self.createLike()
            case .edit(let like):
                self.editLike(like: like)
            case .selectImage:
                self.toSelectImage()
            }
        }
    }
}

// MARK: - Private

private extension LikesCoordinator {
    func toOverview() {
        let likesViewController = factory.makeLikesViewController(coordinator: self,
                                                                  usecaseProvider: self.usecaseProvider)
        navigationController.setViewControllers([likesViewController], animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "Blockstack",
                                                       image: UIImage(named: "blockstack_filled"),
                                                       selectedImage: nil)
        
        let testCoordinator = TestCoordinator(rootViewController: rootViewController, delegate: self, useCaseProvider: usecaseProvider)
        testCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Blockstack",
                                                                     image: UIImage(named: "blockstack_semi_filled"),
                                                                     selectedImage: nil)
        
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            navigationController,
            testCoordinator.navigationController
        ]
        rootViewController.setContentViewController(tabBarController)
        
        addDependency(testCoordinator)
        testCoordinator.start()
    }
    
    func toLikes() {
        navigationController.topViewController?.dismiss(animated: true, completion: nil)
    }
    
    func createLike() {
        let createLikeViewController = factory.makeCreateLikeViewController(coordinator: self,
                                                                            usecaseProvider: self.usecaseProvider,
                                                                            imagesTrigger: imagesTrigger)
        navigationController.pushViewController(createLikeViewController, animated: true)
    }
    
    func editLike(like: Like) {
        let editLikeViewController = factory.makeEditLikeViewController(coordinator: self,
                                                                        usecaseProvider: self.usecaseProvider,
                                                                        imagesTrigger: imagesTrigger,
                                                                        like: like)
        navigationController.pushViewController(editLikeViewController, animated: true)
    }
    
    func toSelectImage() {
        let gallery = GalleryController()
        gallery.delegate = self
        Gallery.Config.tabsToShow = [.imageTab, .cameraTab]
        rootViewController.contentViewController?.present(gallery, animated: true, completion: nil)
    }
}

// MARK: - CoordinatorDelegate

extension LikesCoordinator: CoordinatorDelegate {
    func didFinish(coordinator: AnyCoordinator) {
        removeDependency(coordinator)
    }
}

extension LikesCoordinator: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        Image.resolve(images: images) { (uiImages) in
            self.imagesTrigger.onNext(uiImages[0])
        }
        navigationController.topViewController?.dismiss(animated: true, completion: nil)
        return
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) { return }
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) { return }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        navigationController.topViewController?.dismiss(animated: true, completion: nil)
        return
    }
    
}
