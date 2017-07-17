//
//  StorefrontTests.swift
//  AppleMusicKitTests
//
//  Created by 林達也 on 2017/07/17.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import XCTest
import AppleMusicKit

class StorefrontTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetStorefront() throws {
        try XCTAssertDecodeNoThrow(class: GetStorefront.Response.self, fixture: "get_storefront") { res in
            let attr = res.data.first?.attributes
            XCTAssertEqual(res.data.first?.id, "jp")
            XCTAssertEqual(attr?.name, "Japan")
            XCTAssertEqual(attr?.defaultLanguageTag, "ja-jp")
            XCTAssertEqual(attr?.supportedLanguageTags.set, Set(["ja-jp",
                                                                 "en-us"]))
        }
    }

    func testGetMultipleStorefronts() throws {
        try XCTAssertDecodeNoThrow(class: GetMultipleStorefronts.Response.self, fixture: "get_multiple_storefronts") { res in
            let attr = res.data.first?.attributes
            XCTAssertEqual(res.data.first?.id, "us")
            XCTAssertEqual(attr?.name, "United States")
            XCTAssertEqual(attr?.defaultLanguageTag, "en-us")
            XCTAssertEqual(attr?.supportedLanguageTags.set, Set(["en-us",
                                                                 "es-mx"]))

            XCTAssertEqual(res.data.count, 5)
        }
    }

    func testGetAllStorefronts() throws {
        try XCTAssertDecodeNoThrow(class: GetAllStorefronts.Response.self, fixture: "get_all_storefronts") { res in
            XCTAssertEqual(res.data.count, 155)
        }
    }

    func testGetUsersStorefront() throws {
        try XCTAssertDecodeNoThrow(class: GetStorefront.Response.self, fixture: "get_users_storefront") { res in
            let attr = res.data.first?.attributes
            XCTAssertEqual(res.data.first?.id, "us")
            XCTAssertEqual(attr?.name, "United States")
            XCTAssertEqual(attr?.defaultLanguageTag, "en-us")
            XCTAssertEqual(attr?.supportedLanguageTags.set, Set(["en-us",
                                                                 "es-mx"]))
        }
    }
}
