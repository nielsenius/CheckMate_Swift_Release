//
//  Model.swift
//  CheckMate
//
//  Created by Matthew Nielsen on 10/7/14.
//  Copyright (c) 2014 Matthew Nielsen. All rights reserved.
//

import Foundation

class Model {
    
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
    
//    func setPercentFromCustom() {
//        percent = (custom as NSString).floatValue
//    }
    
    func appendNumToBill(num: String) {
        if bill == "0" {
            bill = num
        } else {
            bill += num
        }
    }
    
//    func appendNumToCustom(num: String) {
//        if custom == "0" {
//            custom = num
//        } else {
//            custom += num
//        }
//    }
    
    func appendSepToBill() {
        if bill.rangeOfString(".") == nil {
            bill += "."
        }
    }
    
//    func appendSepToCustom() {
//        if custom.rangeOfString(".") == nil {
//            custom = "."
//        }
//    }
    
    func deleteBill() {
        if countElements(bill) == 1 {
            bill = "0"
        } else {
            bill = bill.substringToIndex(bill.endIndex.predecessor())
        }
    }
    
//    func deleteCustom() {
//        if countElements(custom) == 1 {
//            custom = "0"
//        } else {
//            custom = custom.substringToIndex(custom.endIndex.predecessor())
//        }
//    }
    
    func clearBill() {
        reset()
//        if bill == "0" {
//            reset()
//        } else {
//            bill = "0"
//        }
    }
    
//    func clearCustom() {
//        if custom == "0" {
//            reset()
//        } else {
//            custom = "0"
//        }
//    }
    
}
