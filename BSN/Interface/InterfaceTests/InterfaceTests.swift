//
//  InterfaceTests.swift
//  InterfaceTests
//
//  Created by Phucnh on 9/21/20.
//

import XCTest
@testable import Interface

class InterfaceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let a = Lauch()
        a.load()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
