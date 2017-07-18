//
//  AlbumTests.swift
//  AppleMusicKitTests
//
//  Created by 林 達也 on 2017/07/18.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import XCTest
import AppleMusicKit

class AlbumTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetAlbum() throws {
        try XCTAssertDecodeNoThrow(class: GetAlbum.Response.self, fixture: "get_album") { res in
            let first = res.data.first
            let attr = first?.attributes
            let rel = first?.relationships
            XCTAssertEqual(res.data.first?.id, "310730204")
            XCTAssertEqual(attr?.name, "Born to Run")
            XCTAssertEqual(rel?.artists.data.count, 1)
            XCTAssertEqual(rel?.tracks.data.count, 8)
        }
    }

    func testGetMultipleAlbums() throws {
        try XCTAssertDecodeNoThrow(class: GetMultipleAlbums.Response.self, fixture: "get_multiple_albums") { res in
            let first = res.data.first
            let attr = first?.attributes
            let rel = first?.relationships
            XCTAssertEqual(res.data.count, 2)
            XCTAssertEqual(res.data.first?.id, "310730204")
            XCTAssertEqual(attr?.name, "Born to Run")
            XCTAssertEqual(rel?.artists.data.count, 1)
            XCTAssertEqual(rel?.tracks.data.count, 8)
        }
    }
}
