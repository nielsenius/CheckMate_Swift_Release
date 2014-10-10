//
//  ViewController.swift
//  CheckMate
//
//  Created by Matthew Nielsen on 9/28/14.
//  Copyright (c) 2014 Matthew Nielsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
    
    @IBAction func splitChanged(sender: AnyObject) {
        
    }
    
    @IBAction func tipChanged(sender: AnyObject) {
        
    }
    
    @IBAction func anyButtonPress(sender: AnyObject) {
        
    }
    
    @IBAction func numButtonRelease(sender: AnyObject) {
        // sender.tag
    }
    
    @IBAction func decimalButtonRelease(sender: AnyObject) {
        
    }
    
    @IBAction func clearButtonRelease(sender: AnyObject) {
        
    }
    
    @IBAction func deleteButtonRelease(sender: AnyObject) {
        
    }
    
    //
    // initialize constants
    //
    
    func setConstants() {
        let moneyColor = UIColor(red: 6 / 256.0, green: 92 / 256.0, blue: 39 / 256.0, alpha: 1)
        let lightGrayColor = UIColor(red: 224 / 256.0, green: 224 / 256.0, blue: 224 / 256.0, alpha: 1)
        let midGrayColor = UIColor(red: 192 / 256.0, green: 192 / 256.0, blue: 192 / 256.0, alpha: 1)
        setCurrencySymbol()
        setThousandsSeparator()
    }
    
    func setCurrencySymbol() {
        if let value = NSUserDefaults.standardUserDefaults().objectForKey("currency") as? String {
            let sym = value
        } else {
            let sym = "$"
        }
    }
    
    func setThousandsSeparator() {
        if let value = NSUserDefaults.standardUserDefaults().objectForKey("separators") as? Int {
            let sep = value
        } else {
            let sep = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // do any additional setup after loading the view
        setConstants()
        
    }

}

