//
//  ZDToolBoxSwiftDemoTests.swift
//  ZDToolBoxSwiftDemoTests
//
//  Created by Zero.D.Saber on 2020/11/10.
//

import XCTest
@testable import ZDToolBoxSwiftDemo
import ZDToolBoxSwift

class ZDToolBoxSwiftDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDebouds() {
        var x = ZDDelay()
        for i in (0...100000) {
            x.debounce(0.05) {
                print("debounce = ", Thread.current, i)
            }
        }
    }

    func testThrottle() {
        var x = ZDDelay()
        for i in (0...100000) {
            x.throttle(0.05) {
                print("throttle = ", Thread.current, i)
            }
        }
    }

}
