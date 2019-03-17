//
//  MockLikesCoordinator.swift
//  PerfectDudeTests
//
//  Created by Yannis De Cleene on 17/03/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import XCTest
@testable import PerfectDude
@testable import Core
import RxSwift

final class MockLikesCoordinator: BaseCoordinator<LikesRoute> {
    public var route: LikesRoute = .overview
    
    override func start() {}
    
    override func coordinate(to route: LikesRoute) {
        self.route = route
    }
}
