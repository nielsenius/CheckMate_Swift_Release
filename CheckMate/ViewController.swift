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
    
    // declare class attributes
    
    var moneyColor: UIColor!
    var lightGrayColor: UIColor!
    var midGrayColor: UIColor!
    var darkGrayColor: UIColor!
    
    var sym: String!
    var sep: Int!
    
    var tockSound: AVAudioPlayer!
    
    var model: Model!
    
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var controlsHeight: CGFloat!
    var keypadHeight: CGFloat!
    var displayHeight: CGFloat!
    
    var keypad: UIView!
    var display: UIView!
    
    var billTextField: UITextField!
    var tipTextField: UITextField!
    var totalTextField: UITextField!
    
    var controls: UIView!
    var splitsLabel: UILabel!
    var sliderLabel: UILabel!
    
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
        
        moneyColor = UIColor(red: 6 / 256.0, green: 92 / 256.0, blue: 39 / 256.0, alpha: 1)
        lightGrayColor = UIColor(red: 224 / 256.0, green: 224 / 256.0, blue: 224 / 256.0, alpha: 1)
        midGrayColor = UIColor(red: 192 / 256.0, green: 192 / 256.0, blue: 192 / 256.0, alpha: 1)
        darkGrayColor = UIColor(red: 38 / 256.0, green: 38 / 256.0, blue: 38 / 256.0, alpha: 1)
        
        sym = getCurrencySymbol()
        sep = getThousandsSeparator()
        
        tockSound = loadTockSound()
        
        model = Model()
        
        screenWidth = UIScreen.mainScreen().bounds.size.width
        screenHeight = UIScreen.mainScreen().bounds.size.height
        controlsHeight = 86
        keypadHeight = calculateKeypadHeight()
        displayHeight = calculateDisplayHeight()
        
        drawDisplay()
        drawControls()
        drawKeypad()
        
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
    
    func loadTockSound() -> AVAudioPlayer {
        var tockFile = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Tock", ofType: "mp3")!)
        var tockSound = AVAudioPlayer(contentsOfURL: tockFile, error: nil)
        tockSound.prepareToPlay()
        
        return tockSound
    }
    
    func calculateKeypadHeight() -> CGFloat {
        switch screenHeight {
        case 480.0:
            return 240
        case 568.0:
            return 320
        case 667.0:
            return 375
        default:
            return 414
        }
    }
    
    func calculateDisplayHeight() -> CGFloat {
        return screenHeight - controlsHeight - keypadHeight
    }
    
    func playTockSound() {
        tockSound.play()
    }
    
    func redrawDisplay() {
        billTextField.text = sym + model.bill
        tipTextField.text = sym + model.tip
        
        if model.splits > 1 {
            totalTextField.text = "\(sym)\(model.total) x \(model.splits)"
            splitsLabel.text = "Split \(model.splits) ways"
        } else {
            totalTextField.text = sym + model.total
            splitsLabel.text = "Split 1 way"
        }
        
        sliderLabel.text = "Tip \(Int(model.percent))%"
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
    
    func drawDisplay() {
        display = UIView(frame: CGRectMake(0, 0, screenWidth, displayHeight))
        display.backgroundColor = darkGrayColor
        
        
        var margin: CGFloat = 6
        
        var labelWidth: CGFloat = 52
        var labelHeight: CGFloat = 17
        var labelFontSize: CGFloat = 13
        
        var numHeight: CGFloat = 40
        var numFontSize: CGFloat = 36
        
        var firstSpace: CGFloat = 20
        var secondSpace: CGFloat = displayHeight / 3 + 10
        var thirdSpace: CGFloat = displayHeight / 3 * 2
        
        
        var billLabel = UILabel(frame: CGRectMake(margin, firstSpace, labelWidth, labelHeight))
        billLabel.text = "Enter bill"
        billLabel.font = UIFont(name: billLabel.font.fontName, size: labelFontSize)
        billLabel.textColor = UIColor.whiteColor()
        display.addSubview(billLabel)
        
        billTextField = UITextField(frame: CGRectMake(margin + labelWidth, firstSpace, screenWidth - labelWidth - margin * 2, numHeight))
        billTextField.text = "$0"
        billTextField.font = UIFont(name: billLabel.font.fontName, size: numFontSize)
        billTextField.textColor = UIColor.whiteColor()
        billTextField.textAlignment = .Right
        display.addSubview(billTextField)
        
        
        var tipLabel = UILabel(frame: CGRectMake(margin, secondSpace, labelWidth, labelHeight))
        tipLabel.text = "Tip"
        tipLabel.font = UIFont(name: tipLabel.font.fontName, size: labelFontSize)
        tipLabel.textColor = UIColor.whiteColor()
        display.addSubview(tipLabel)
        
        tipTextField = UITextField(frame: CGRectMake(margin + labelWidth, secondSpace, screenWidth - labelWidth - margin * 2, numHeight))
        tipTextField.text = "$0"
        tipTextField.font = UIFont(name: billLabel.font.fontName, size: numFontSize)
        tipTextField.textColor = UIColor.whiteColor()
        tipTextField.textAlignment = .Right
        display.addSubview(tipTextField)
        
        
        var totalLabel = UILabel(frame: CGRectMake(margin, thirdSpace, labelWidth, labelHeight))
        totalLabel.text = "Total"
        totalLabel.font = UIFont(name: totalLabel.font.fontName, size: labelFontSize)
        totalLabel.textColor = UIColor.whiteColor()
        display.addSubview(totalLabel)
        
        totalTextField = UITextField(frame: CGRectMake(margin + labelWidth, thirdSpace, screenWidth - labelWidth - margin * 2, numHeight))
        totalTextField.text = "$0"
        totalTextField.font = UIFont(name: billLabel.font.fontName, size: numFontSize)
        totalTextField.textColor = UIColor.whiteColor()
        totalTextField.textAlignment = .Right
        display.addSubview(totalTextField)
        
        
        self.view.addSubview(display)
    }
    
    func drawControls() {
        controls = UIView(frame: CGRectMake(0, displayHeight, screenWidth, controlsHeight)) // x, y, width, height
        controls.backgroundColor = UIColor.whiteColor()
        
        var divider = UIView(frame: CGRectMake(0, controlsHeight / 2, screenWidth, 0.5))
        divider.backgroundColor = UIColor.blackColor()
        controls.addSubview(divider)
        
        splitsLabel = UILabel(frame: CGRectMake(6, 12, 100, 20))
        splitsLabel.text = "Split 1 way"
        controls.addSubview(splitsLabel)
        
        stepper = UIStepper(frame: CGRectMake(screenWidth - 101, 7, 0, 0))
        stepper.tintColor = moneyColor
        controls.addSubview(stepper)
        
        sliderLabel = UILabel(frame: CGRectMake(6, 55, 100, 20))
        sliderLabel.text = "Tip 20%"
        controls.addSubview(sliderLabel)
        
        slider = UISlider(frame: CGRectMake(100, 65, screenWidth - 106, 0))
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.continuous = true
        slider.tintColor = moneyColor
        slider.value = 20
        // slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        controls.addSubview(slider)
        
        self.view.addSubview(controls)
    }
    
    func drawKeypad() {
        keypad = UIView(frame: CGRectMake(0, displayHeight + controlsHeight, screenWidth, keypadHeight))
        
        var keyWidth: CGFloat = screenWidth / 4
        var numFontSize: CGFloat = 36
        
        
        self.view.addSubview(keypad)
    }
    
}
