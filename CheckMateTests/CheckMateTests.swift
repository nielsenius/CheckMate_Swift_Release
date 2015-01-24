//
//  CheckMateTests.swift
//  CheckMateTests
//
//  Created by Matthew Nielsen on 9/28/14.
//  Copyright (c) 2014 Matthew Nielsen. All rights reserved.
//

//import UIKit
//import XCTest
//
//class CheckMateTests: XCTestCase {
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func testExample() {
//        // This is an example of a functional test case.
//        XCTAssert(true, "Pass")
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
//    
//}

import Quick
import Nimble
import CheckMate

class CheckMateSpec: QuickSpec {
    
    override func spec() {
        
        // testing basic attributes and their initial values
        describe("model has correct attributes") {
            
            let model = Model()
            
            it("has a percent attribute") {
                expect(model.percent).to(equal(0.2))
                expect(model.percent).notTo(equal(0.1))
            }
            
            it("has a bill attribute") {
                expect(model.bill).to(equal("0"))
                expect(model.bill).notTo(equal("1"))
            }
            
            it("has a splits attribute") {
                expect(model.splits).to(equal(1))
                expect(model.splits).notTo(equal(0))
            }
            
            it("has a billFloat attribute") {
                expect(model.billFloat).to(equal(0.0))
                expect(model.billFloat).notTo(equal(1.0))
            }
            
            it("has a tip attribute") {
                expect(model.tip).to(equal(0.0))
                expect(model.tip).notTo(equal(1.0))
            }
            
            it("has a total attribute") {
                expect(model.total).to(equal(0.0))
                expect(model.total).notTo(equal(1.0))
            }
        }
        
        // testing methods
        describe("model behavior") {
            
            // example of using an optional
            var model = Model()
            beforeEach {
                model.reset()
            }
            
            context("when a number is appended to the bill") {
                it("has a bill amount of 1") {
                    model.appendNumToBill("1")
                    
                    expect(model.bill).to(equal("1"))
                    expect(model.bill).notTo(equal("0"))
                }
            }
            
            context("when a decimal is appended to the bill") {
                it("has a bill amount of 0.") {
                    model.appendDecimalToBill()
                    
                    expect(model.bill).to(equal("0."))
                    expect(model.bill).notTo(equal("."))
                }
            }
            
            context("when a character is deleted from the bill") {
                it("has a bill amount of 0") {
                    model.appendNumToBill("1")
                    model.deleteBill()
                    
                    expect(model.bill).to(equal("0"))
                    expect(model.bill).notTo(equal("1"))
                }
            }
        }
    }
}
