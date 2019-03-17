//
//  LikeTests.swift
//  CoreTests
//
//  Created by Yannis De Cleene on 17/03/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import XCTest
@testable import Core

class LikeTests: XCTestCase {
    var like: Like!

    override func setUp() {
        let likeJsonData = """
        {
            "description": "Birthday",
            "tags": ["gift", "girl"],
            "image": "",
            "uuid": "982FC894-AA05-489D-8BD4-A0C246B4244B",
            "encrypted": true
        }
        """
        
        guard let data = likeJsonData.data(using: .utf8) else {
            print("Error: No data to decode")
            return
        }
        
        guard let likeDecoded = try? JSONDecoder().decode(Like.self, from: data) else {
            print("Error: Couldn't decode json into Like")
            return
        }
        
        like = likeDecoded
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJsonDecoding() {
        XCTAssertEqual(like.description, "Birthday")
        XCTAssertEqual(like.tags, ["gift", "girl"])
        XCTAssertEqual(like.image, nil)
        XCTAssertEqual(like.uuid, "982FC894-AA05-489D-8BD4-A0C246B4244B")
        XCTAssertEqual(like.encrypted, true)
    }

}
