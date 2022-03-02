//
//  arplasticoceanTests.swift
//  arplasticoceanTests
//
//  Created by Yasuhito NAGATOMO on 2022/02/21.
//

import XCTest

class ARPlasticOceanTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFloatNormalizeRadian() {
        let pi2: Float = Float.pi * 2.0
        let angle1: Float = Float.pi
        let angle2: Float = Float.pi * 3.0
        let angle3: Float = -Float.pi
        let angle4: Float = -Float.pi * 3.0
        XCTAssert(Float.normalize(radian: angle1) < pi2
                  && Float.normalize(radian: angle1) > -pi2)
        XCTAssert(Float.normalize(radian: angle2) < pi2
                  && Float.normalize(radian: angle2) > -pi2)
        XCTAssert(Float.normalize(radian: angle3) < pi2
                  && Float.normalize(radian: angle3) > -pi2)
        XCTAssert(Float.normalize(radian: angle4) < pi2
                  && Float.normalize(radian: angle4) > -pi2)
    }

//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete.
//        // Check the results with assertions afterwards.
//    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
