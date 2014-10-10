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
    var custom: String
    
    let maxSplits: Int
    let minSplits: Int
    
    var tip: String {
        get {
            var billFloat = (bill as NSString).floatValue
            return String(format: "%.2f", billFloat * percent)
        }
    }
    var total: String {
        get {
            var billFloat = (bill as NSString).floatValue
            return String(format: "%.2f", billFloat + (billFloat * percent) / Float(splits))
        }
    }
    
    init() {
        percent = 0.00
        bill = "0"
        splits = 1
        custom = "0"
        
        maxSplits = 99
        minSplits = 1
    }
    
    func setPercent(tag: Int) {
        switch tag {
        case 16:
            percent = 0.00
        case 17:
            percent = 0.10
        case 18:
            percent = 0.15
        default:
            percent = 0.20
        }
    }
    
    func setPercentFromCustom() {
        percent = (custom as NSString).floatValue
    }
    
    func addSplit() {
        if splits < maxSplits {
            splits += 1
        }
    }
    
    func subSplit() {
        if splits > minSplits {
            splits -= 1
        }
    }
    
}
