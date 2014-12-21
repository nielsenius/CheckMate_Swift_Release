//
//  ViewController.swift
//  CheckMate
//
//  Created by Matthew Nielsen on 9/28/14.
//  Copyright (c) 2014 Matthew Nielsen. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let moneyColor = UIColor(red: 6 / 256.0, green: 92 / 256.0, blue: 39 / 256.0, alpha: 1)
    let lightGrayColor = UIColor(red: 224 / 256.0, green: 224 / 256.0, blue: 224 / 256.0, alpha: 1)
    let midGrayColor = UIColor(red: 192 / 256.0, green: 192 / 256.0, blue: 192 / 256.0, alpha: 1)
    
    let sym = ViewController.getCurrencySymbol()
    let sep = ViewController.getThousandsSeparator()
    
    let tockSound = ViewController.loadTockSound()
    
    var model = Model()
    
    let displayWidth = UIScreen.mainScreen().bounds.size.width
    let displayHeight = UIScreen.mainScreen().bounds.size.height
    
    //
    // IBOutlets
    //
    
    var keypad: UIView!
    
    var billTextField: UITextField!
    var tipTextField: UITextField!
    var totalTextField: UITextField!
    
    var splitsTextField: UITextField!
    var sliderTextField: UITextField!
    
    var slider: UISlider!
    var stepper: UIStepper!
    
    //
    // IBActions
    //
    
    func splitChanged(sender: UIStepper) {
        model.splits = Int(sender.value)
        redrawDisplay()
    }
    
    func tipChanged(sender: UISlider) {
        model.setPercent(round(sender.value * 100))
        redrawDisplay()
    }
    
    func anyButtonPress(sender: UIButton) {
        if sender.tag == 12 || sender.tag == 13 {
            sender.backgroundColor = midGrayColor
        } else {
            sender.backgroundColor = lightGrayColor
        }
        playTockSound()
    }
    
    func numButtonRelease(sender: UIButton) {
        model.appendNumToBill(String(sender.tag))
        animateButtonRelease(sender)
        redrawDisplay()
    }
    
    func decimalButtonRelease(sender: UIButton) {
        model.appendSepToBill()
        animateButtonRelease(sender)
        redrawDisplay()
    }
    
    func clearButtonRelease(sender: UIButton) {
        model.clearBill()
        animateButtonRelease(sender)
        redrawDisplay()
    }
    
    func deleteButtonRelease(sender: UIButton) {
        model.deleteBill()
        animateButtonRelease(sender)
        redrawDisplay()
    }
    
    //
    // other functions
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(UIScreen.mainScreen().bounds.size.height)
        
//        if UIScreen.mainScreen().bounds.size.height > 568.0 {
//            self.view.addConstraint(NSLayoutConstraint(item: self.keypad, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.keypad, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
//            )
//        }
//        
//        redrawDisplay()
    }
    
    // How to set the orientation. The return value is not what we expect, Int not UInt so we cast.
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
    
    class func getCurrencySymbol() -> String {
        if let value = NSUserDefaults.standardUserDefaults().objectForKey("currency") as? String {
            return value
        } else {
            return "$"
        }
    }
    
    class func getThousandsSeparator() -> Int {
        if let value = NSUserDefaults.standardUserDefaults().objectForKey("separators") as? Int {
            return value
        } else {
            return 0
        }
    }
    
    class func loadTockSound() -> AVAudioPlayer {
        var tockFile = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Tock", ofType: "mp3")!)
        var tockSound = AVAudioPlayer(contentsOfURL: tockFile, error: nil)
        tockSound.prepareToPlay()
        
        return tockSound
    }
    
    func playTockSound() {
        tockSound.play()
    }
    
    func redrawDisplay() {
        billTextField.text = sym + model.bill
        tipTextField.text = sym + model.tip
        
        if model.splits > 1 {
            totalTextField.text = "\(sym)\(model.total) x \(model.splits)"
            splitsTextField.text = "Split \(model.splits) ways"
        } else {
            totalTextField.text = sym + model.total
            splitsTextField.text = "Split 1 way"
        }
        
        sliderTextField.text = "Tip \(Int(model.percent))%"
        slider.setValue(model.percent / 100, animated: true)
        stepper.value = Double(model.splits)
    }
    
    func animateButtonRelease(sender: UIButton) {
        UIView.animateWithDuration(0.3,
            delay: 0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                if sender.tag == 12 || sender.tag == 13 {
                    sender.backgroundColor = self.lightGrayColor
                } else {
                    sender.backgroundColor = UIColor.whiteColor()
                }
            }, completion: {
                finished in
            }
        )
    }
    
    func drawKeypad() {
        let view1 = UIView()
        view1.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
}

