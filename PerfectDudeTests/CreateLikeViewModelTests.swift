//
//  CreateLikeViewModelTests.swift
//  PerfectDudeTests
//
//  Created by Yannis De Cleene on 17/03/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import XCTest
@testable import PerfectDude
@testable import Core
import RxSwift
import RxCocoa
import RxTest
import TagListView

final class CreateLikeViewModelTests: XCTestCase {
    private var useCaseProvider: Core.UseCaseProvider!
    private var viewModel: CreateLikeViewModel!
    private let coordinator = MockLikesCoordinator()
    private let imagesTrigger = PublishSubject<UIImage?>()
    private let void = "voidEvent"
    
    override func setUp() {
        super.setUp()
        useCaseProvider = MockUseCaseProvider()
        viewModel = CreateLikeViewModel(coordinator: coordinator,
                                        useCaseProvider: useCaseProvider,
                                        imagesTrigger: imagesTrigger)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testViewModel() {
        let scheduler = TestScheduler(initialClock: 0, resolution: 1, simulateProcessingDelay: false)
        
        let booleans = [
            "f": false,
            "t": true
        ]
        
        let firstName = scheduler
            .createHotObservable([
                next(1, "John"),
                completed(10)
                ])
            .asDriver(onErrorJustReturn: "")
        
        let lastName = scheduler
            .createHotObservable([
                next(2, true),
                completed(10)
                ])
            .asDriver(onErrorJustReturn: false)
        
        let phoneNumberText = scheduler
            .createHotObservable([
                next(3, [TagView(title: "Gift")]),
                completed(10)
                ])
            .asDriver(onErrorJustReturn: [])
        
        let tagDeleteTrigger = scheduler
            .createHotObservable([
                next(3, TagView(title: "Gift")),
                completed(10)
                ])
            .asDriver(onErrorJustReturn: TagView(title: "Gift"))
        
        let nextTap = scheduler
            .createHotObservable([
                completed(10)
                ])
            .asDriver(onErrorJustReturn: ())
        
        SharingScheduler.mock(scheduler: scheduler) {
            let input = CreateLikeViewModel.Input(trigger: nextTap,
                                                  editTrigger: nextTap,
                                                  deleteTrigger: nextTap,
                                                  selectImageTrigger: nextTap,
                                                  likeTitle: firstName,
                                                  tags: phoneNumberText,
                                                  encryption: lastName,
                                                  tagDeleteTrigger: tagDeleteTrigger,
                                                  newTagTitle: firstName,
                                                  newTagTrigger: nextTap)
            
            let output = viewModel.transform(input: input)
            let expectedEnabledBools = scheduler.parseEventsAndTimes(timeline: "f----t----|", values: booleans).first!
            let nextEnabled = scheduler.record(source: output.saveEnabled)
            
            
            scheduler.start()
            XCTAssertEqual(nextEnabled.events, expectedEnabledBools)
        }
    }
}
