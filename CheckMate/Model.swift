//
//  Model.swift
//  CheckMate
//
//  Created by Matthew Nielsen on 10/7/14.
//  Copyright (c) 2014 Matthew Nielsen. All rights reserved.
//

import Foundation

class Model {
    
    //
    // declare class attributes
    //
    
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
    
    //
    // object instantiated
    //
    
    // class constructor
    init() {
        percent = 0.2
        bill = "0"
        splits = 1
    }
    
    // reset all values
    func reset() {
        percent = 0.2
        bill = "0"
        splits = 1
    }
    
    // setter for percent
    func setPercent(percent: Float) {
        self.percent = percent
    }
    
    // setter for splits
    func setSplits(splits: Int) {
        self.splits = splits
    }
    
    // takes a string and appends it to the end of bill
    func appendNumToBill(num: String) {
        if bill == "0" {
            bill = num
        } else {
            bill += num
        }
    }
    
    // takes "." and appends it to bill
    func appendDecimalToBill() {
        if bill.rangeOfString(".") == nil {
            bill += "."
        }
    }
    
    // deletes the last character from bill
    func deleteBill() {
        if countElements(bill) == 1 {
            bill = "0"
        } else {
            bill = bill.substringToIndex(bill.endIndex.predecessor())
        }
    }
    
}
