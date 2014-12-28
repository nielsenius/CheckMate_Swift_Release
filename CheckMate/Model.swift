//
//  Model.swift
//  CheckMate
//
//  Created by Matthew Nielsen on 10/7/14.
//  Copyright (c) 2014 Matthew Nielsen. All rights reserved.
//

import Foundation

class Model {
    
    // declare class attributes
    
    var percent: Float
    var bill: String
    var splits: Int
    
    var billFloat: Float {
        get {
            return NSString(string: bill).floatValue
        }
    }
    
    var tip: Float {
        get {
            return billFloat * percent
        }
    }
    
    var total: Float {
        get {
            return (billFloat + tip) / Float(splits)
        }
    }
    
    // class constructor
    init() {
        percent = 0.2
        bill = "0"
        splits = 1
    }
    
    func reset() {
        percent = 0.2
        bill = "0"
        splits = 1
    }
    
    func setPercent(percent: Float) {
        self.percent = percent
    }
    
    func appendNumToBill(num: String) {
        if bill == "0" {
            bill = num
        } else {
            bill += num
        }
    }
    
    func appendDecimalToBill() {
        if bill.rangeOfString(".") == nil {
            bill += "."
        }
    }
    
    func deleteBill() {
        if countElements(bill) == 1 {
            bill = "0"
        } else {
            bill = bill.substringToIndex(bill.endIndex.predecessor())
        }
    }
    
    func clearBill() {
        reset()
    }
    
}
