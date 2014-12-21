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
    
    var tip: String {
        get {
            var billFloat = (bill as NSString).floatValue
            return String(format: "%.2f", billFloat * percent / 100)
        }
    }
    var total: String {
        get {
            var billFloat = (bill as NSString).floatValue
            return String(format: "%.2f", (billFloat + (billFloat * percent / 100)) / Float(splits))
        }
    }
    
    // class constructor
    init() {
        percent = 20.0
        bill = "0"
        splits = 1
    }
    
    func reset() {
        percent = 20.0
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
    
    func appendSepToBill() {
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
