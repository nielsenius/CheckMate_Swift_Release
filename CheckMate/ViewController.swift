//
//  ViewController.swift
//  CheckMate
//
//  Created by Matthew Nielsen on 9/28/14.
//  Copyright (c) 2014 Matthew Nielsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    let moneyColor = UIColor(red: 6 / 256.0, green: 92 / 256.0, blue: 39 / 256.0, alpha: 1)
    let lightGrayColor = UIColor(red: 224 / 256.0, green: 224 / 256.0, blue: 224 / 256.0, alpha: 1)
    let midGrayColor = UIColor(red: 192 / 256.0, green: 192 / 256.0, blue: 192 / 256.0, alpha: 1)
    
    //let sym = getCurrencySymbol()
    //let sep = getThousandsSeparator()
    
    var model = Model()
    
    //
    // IBOutlets
    //
    
    @IBOutlet var billTextField: UITextField!
    @IBOutlet var tipTextField: UITextField!
    @IBOutlet var totalTextField: UITextField!
    
    @IBOutlet var splitsTextField: UITextField!
    
    //
    // IBActions
    //
    
    @IBAction func splitChanged(sender: UIStepper) {
        model.splits = Int(sender.value)
        redrawDisplay()
    }
    
    @IBAction func tipChanged(sender: UISegmentedControl) {
        var segmentIdx = sender.selectedSegmentIndex
        if segmentIdx == 4 {
            // custom percent
        } else {
            model.setPercent(segmentIdx)
        }
    }
    
    @IBAction func anyButtonPress(sender: UIButton) {
        // animation
    }
    
    @IBAction func numButtonRelease(sender: UIButton) {
        model.appendNumToBill(String(sender.tag))
        redrawDisplay()
    }
    
    @IBAction func decimalButtonRelease(sender: UIButton) {
        model.appendSepToBill()
        redrawDisplay()
    }
    
    @IBAction func clearButtonRelease(sender: UIButton) {
        
    }
    
    @IBAction func deleteButtonRelease(sender: UIButton) {
        
    }
    
    //
    // other functions
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // do any additional setup after loading the view
    }
    
    func getCurrencySymbol() -> String {
        if let value = NSUserDefaults.standardUserDefaults().objectForKey("currency") as? String {
            return value
        } else {
            return "$"
        }
    }
    
    func getThousandsSeparator() -> Int {
        if let value = NSUserDefaults.standardUserDefaults().objectForKey("separators") as? Int {
            return value
        } else {
            return 0
        }
    }
    
    func redrawDisplay() {
        billTextField.text = model.bill
    }

}

