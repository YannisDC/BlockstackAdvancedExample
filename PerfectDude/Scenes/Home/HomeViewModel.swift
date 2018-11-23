//
//  HomeViewModel.swift
//  MealPlan
//
//  Created by Yannis De Cleene on 14/09/2018.
//  Copyright © 2018 CSStudios. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Core

final class HomeViewModel: ViewModel {
    
    private weak var coordinator: BaseCoordinator<HomeRoute>?
    private var likeUsecase = UseCaseProvider().blockstackUseCaseProvider.makeLikesUseCase()
    private var initUsecase = UseCaseProvider().blockstackUseCaseProvider.makeInitUseCase()
    fileprivate let imagesTrigger: PublishSubject<UIImage?>
    
    fileprivate var likes = Variable<[Like?]>([])
    
    // MARK: Init
    
    init(coordinator: BaseCoordinator<HomeRoute>?,
         imagesTrigger: PublishSubject<UIImage?>) {
        self.coordinator = coordinator
        self.imagesTrigger = imagesTrigger
    }
    
    // MARK: Transform
    
    func transform(input: HomeViewModel.Input) -> HomeViewModel.Output {
        let title = Driver.just("onboarding_set_your_pin_title".localized())
        
        let signOutResult = input.signOutTap.do(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            
//            self.initUsecase.initLikeIndexes().subscribe(onSuccess: { (path) in
//                print(path)
//            }, onError: { (error) in
//                print(error)
//            })
            
//            self.coordinator?.coordinate(to: .signOut)
        })
        
        let pinButtonTap = input.buttonTap.do(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            
//            self.usecase.loadImage(path: "testFile", decrypt: true)
//                .subscribe(onNext: { (image) in
//                    print(image)
//                }, onError: { (error) in
//
//                })
            
            self.coordinator?.coordinate(to: .nextScreen)
        })
        
//        let image = self.usecase.loadImage(path: "testFile", decrypt: true).asDriver(onErrorJustReturn: nil)
//
//        let imageToSave = imagesTrigger.asDriver(onErrorJustReturn: nil)
//
//        let showResult = input.showTap
//
//        // TODO: UploadConfirmation output Driver<Bool> that shows some animation or coordinates to new viewcontroller
//        let uploadConfirmation = showResult
//            .withLatestFrom(imageToSave)
//            .flatMapLatest { (image) -> Driver<String?> in
//
//                guard let image = image else { return Driver.just(nil) }
//                return self.usecase.saveImage(path: "testFile", image: image, encrypt: true).do(onNext: { (path) in
//                    print(path)
//                }).asDriver(onErrorJustReturn: nil)
//        }
        
        return Output(tapResult: pinButtonTap,
                      signOutResult: signOutResult,
//                      showResult: showResult,
                      title: title)
                      //image: image,
//                      imageToSave: imageToSave,
//                      uploadConfirmation: uploadConfirmation)
    }
}

// MARK: - ViewModel

extension HomeViewModel {
    struct Input {
        let buttonTap: Driver<Void>
        let signOutTap: Driver<Void>
        let showTap: Driver<Void>
    }
    
    struct Output {
        let tapResult: Driver<Void>
        let signOutResult: Driver<Void>
//        let showResult: Driver<Void>
        let title: Driver<String>
//        let image: Driver<UIImage?>
//        let imageToSave: Driver<UIImage?>
//        let uploadConfirmation: Driver<String?>
    }
}
