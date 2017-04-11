//
//  RegexTest.swift
//  NowPlayingFormatterTests
//
//  Created by mironal on 2017/04/09.
//  Copyright © 2017年 covelline. All rights reserved.
//

import XCTest
@testable import NowPlayingFormatter

class RegexTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBrace() {
        let regex = NSRegularExpression.braceRegex

        let text = "aa${AC A}bb ${aaa ${a}}cc${}c"
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))

        XCTAssertEqual(matches.count, 2)
    }

    func testFormat() {

        let regex = NSRegularExpression.formatRegex
        XCTAssertNotNil(regex)

        let  text = "%at%a%l"
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))

        XCTAssertEqual(matches.count, 3)
    }
}
