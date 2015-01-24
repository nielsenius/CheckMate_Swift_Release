//
//  ViewController.swift
//  CheckMate
//
//  Created by Matthew Nielsen on 9/28/14.
//  Copyright (c) 2014 Matthew Nielsen. All rights reserved.
//

import UIKit
import AVFoundation

// extension to the String class to allow for bracket access to characters
extension String {
    
    // access a one-character substring like this: "string"[0]
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
    
    // access a multi-character substring like this: "string"[0...2]
    subscript(integerRange: Range<Int>) -> String {
        let start = advance(startIndex, integerRange.startIndex)
        let end = advance(startIndex, integerRange.endIndex)
        let range = start..<end
        return self[range]
    }
    
}

class ViewController: UIViewController {
    
    //
    // class attribute declarations
    //
    
    // colors
    var moneyColor: UIColor!
    var lightGrayColor: UIColor!
    var midGrayColor: UIColor!
    var darkGrayColor: UIColor!
    
    // important data
    var tockSound: AVAudioPlayer!
    var currencySymbol: String!
    
    // where the numbers are stored
    var model: Model!
    
    // values for drawing the UI
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var controlsHeight: CGFloat!
    var keypadHeight: CGFloat!
    var displayHeight: CGFloat!
    var dividerSize: CGFloat!
    
    // three main UI components
    var display: UIView!
    var controls: UIView!
    var keypad: UIView!
    
    // display components
    var billTextField: UITextField!
    var tipTextField: UITextField!
    var totalTextField: UITextField!
    
    // controls components
    var splitsLabel: UILabel!
    var sliderLabel: UILabel!
    var slider: UISlider!
    var stepper: UIStepper!
    
    //
    // app is loaded
    //
    
    // initial setup when the app is launched
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup colors
        moneyColor = UIColor(red: 6 / 256.0, green: 92 / 256.0, blue: 39 / 256.0, alpha: 1)
        lightGrayColor = UIColor(red: 224 / 256.0, green: 224 / 256.0, blue: 224 / 256.0, alpha: 1)
        midGrayColor = UIColor(red: 192 / 256.0, green: 192 / 256.0, blue: 192 / 256.0, alpha: 1)
        darkGrayColor = UIColor(red: 38 / 256.0, green: 38 / 256.0, blue: 38 / 256.0, alpha: 1)
        
        // setup important data
        tockSound = loadTockSound()
        currencySymbol = "$"
        
        // instantiate the model
        model = Model()
        
        // load values for drawing the UI
        screenWidth = UIScreen.mainScreen().bounds.size.width
        screenHeight = UIScreen.mainScreen().bounds.size.height
        controlsHeight = 86
        keypadHeight = calculateKeypadHeight()
        displayHeight = calculateDisplayHeight()
        dividerSize = calculateDividerSize()
        
        // draw the UI
        drawDisplay()
        drawControls()
        drawKeypad()
    }
    
    //
    // event handlers
    //
    
    // when the bill splitter is pressed
    func splitChanged(sender: UIStepper) {
        model.setSplits(Int(sender.value))
        redrawDisplay()
    }
    
    // when the tip setter slides
    func tipChanged(sender: UISlider) {
        model.setPercent(round(sender.value * 100) / 100)
        redrawDisplay()
    }
    
    // any key in the keypad is pressed
    func anyButtonPress(sender: UIButton) {
        if sender.tag == 12 || sender.tag == 13 {
            // C and Del keys
            sender.backgroundColor = midGrayColor
        } else {
            // all other keys
            sender.backgroundColor = lightGrayColor
        }
        playTockSound()
    }
    
    // numeric key is released from press
    func numButtonRelease(sender: UIButton) {
        model.appendNumToBill(String(sender.tag))
        animateButtonRelease(sender)
        redrawDisplay()
    }
    
    // . key is released from press
    func decimalButtonRelease(sender: UIButton) {
        model.appendDecimalToBill()
        animateButtonRelease(sender)
        redrawDisplay()
    }
    
    // C key is released from press
    func clearButtonRelease(sender: UIButton) {
        model.reset()
        animateButtonRelease(sender)
        redrawDisplay()
    }
    
    // Del key is released from press
    func deleteButtonRelease(sender: UIButton) {
        model.deleteBill()
        animateButtonRelease(sender)
        redrawDisplay()
    }
    
    //
    // other functions
    //
    
    // prepare the tock sound to be played when a key is pressed
    func loadTockSound() -> AVAudioPlayer {
        // create an an audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryAmbient, error: nil)
        
        // load Tock.mp3
        var tockFile = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Tock", ofType: "mp3")!)
        var tockSound = AVAudioPlayer(contentsOfURL: tockFile, error: nil)
        tockSound.volume = 0.5
        // tock sound ready to play at any time
        tockSound.prepareToPlay()
        
        return tockSound
    }
    
    // set the size of the keypad based on screen size
    func calculateKeypadHeight() -> CGFloat {
        switch screenHeight {
        case 480.0:
            return 218
        case 568.0:
            return 320
        case 667.0:
            return 375
        case 736:
            return 414
        default:
            return 490
        }
    }
    
    // set the size of the money display based on screen size
    func calculateDisplayHeight() -> CGFloat {
        return screenHeight - controlsHeight - keypadHeight
    }
    
    // calculate how thick dividing lines should be based on pixel density
    func calculateDividerSize() -> CGFloat {
        switch UIScreen.mainScreen().scale {
        case 1.0:
            return 1.0
        case 2.0:
            return 0.5
        default:
            return 1 / 3
        }
    }
    
    // play the tock sound
    func playTockSound() {
        tockSound.play()
    }
    
    // subtle animation when a key is released
    func animateButtonRelease(sender: UIButton) {
        UIView.animateWithDuration(0.3,
            delay: 0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                if sender.tag == 12 || sender.tag == 13 {
                    // C and Del keys
                    sender.backgroundColor = self.lightGrayColor
                } else {
                    // all other keys
                    sender.backgroundColor = UIColor.whiteColor()
                }
            }, completion: {
                finished in
            }
        )
    }
    
    //
    // functions for drawing the UI
    //
    
    // redraws the money display and the controls when a change is made
    func redrawDisplay() {
        // update bill amount display
        billTextField.text = currencySymbol + model.bill
        
        // update tip amount display
        if model.bill == "0" {
            tipTextField.text = ""
        } else {
            tipTextField.text = currencySymbol + String(format: "%.2f", model.tip)
        }
        
        if model.splits > 1 {
            // update total amount display
            if model.bill == "0" {
                totalTextField.text = ""
            } else {
                totalTextField.text = currencySymbol + String(format: "%.2f", model.total) + " x \(model.splits)"
            }
            // update number of splits display
            splitsLabel.text = "Split \(model.splits) ways"
        } else {
            // update total amount display
            if model.bill == "0" {
                totalTextField.text = ""
            } else {
                totalTextField.text = currencySymbol + String(format: "%.2f", model.total)
            }
            // update number of splits display
            splitsLabel.text = "Split 1 way"
        }
        
        // update the tip slider and its label (for when C is hit or when the slider is moved because its value is rounded)
        sliderLabel.text = "Tip \(Int(model.percent * 100))%"
        slider.setValue(model.percent, animated: true)
        // update the splits stepper (for when C is hit)
        stepper.value = Double(model.splits)
    }
    
    // draw the money display section of the UI
    func drawDisplay() {
        // instantiate the display UIView
        display = UIView(frame: CGRectMake(0, 0, screenWidth, displayHeight))
        display.backgroundColor = darkGrayColor
        
        
        // calculate values for drawing elements
        var margin: CGFloat = 6
        
        var labelWidth: CGFloat = 52
        var labelHeight: CGFloat = 17
        var labelFontSize: CGFloat = 13
        
        var numFontSize: CGFloat = displayHeight / 4
        var numHeight: CGFloat = numFontSize + 4
        
        var firstSpace: CGFloat = 20
        var secondSpace: CGFloat = displayHeight / 3 + 10
        var thirdSpace: CGFloat = displayHeight / 3 * 2
        
        
        // draw the bill elements
        var billLabel = UILabel(frame: CGRectMake(margin, firstSpace, labelWidth, labelHeight))
        billLabel.text = "Enter bill"
        billLabel.font = UIFont(name: billLabel.font.fontName, size: labelFontSize)
        billLabel.textColor = UIColor.whiteColor()
        display.addSubview(billLabel)
        
        billTextField = UITextField(frame: CGRectMake(margin + labelWidth, firstSpace, screenWidth - labelWidth - margin * 2, numHeight))
        billTextField.text = "$0"
        billTextField.font = UIFont(name: "HelveticaNeue-UltraLight", size: numFontSize)
        billTextField.textColor = UIColor.whiteColor()
        billTextField.textAlignment = .Right
        billTextField.userInteractionEnabled = false
        billTextField.adjustsFontSizeToFitWidth = true
        display.addSubview(billTextField)
        
        
        // draw the tip elements
        var tipLabel = UILabel(frame: CGRectMake(margin, secondSpace, labelWidth, labelHeight))
        tipLabel.text = "Tip"
        tipLabel.font = UIFont(name: tipLabel.font.fontName, size: labelFontSize)
        tipLabel.textColor = UIColor.whiteColor()
        display.addSubview(tipLabel)
        
        tipTextField = UITextField(frame: CGRectMake(margin + labelWidth, secondSpace, screenWidth - labelWidth - margin * 2, numHeight))
        tipTextField.text = ""
        tipTextField.font = UIFont(name: "HelveticaNeue-UltraLight", size: numFontSize)
        tipTextField.textColor = UIColor.whiteColor()
        tipTextField.textAlignment = .Right
        tipTextField.userInteractionEnabled = false
        tipTextField.adjustsFontSizeToFitWidth = true
        display.addSubview(tipTextField)
        
        
        // draw the total elements
        var totalLabel = UILabel(frame: CGRectMake(margin, thirdSpace, labelWidth, labelHeight))
        totalLabel.text = "Total"
        totalLabel.font = UIFont(name: totalLabel.font.fontName, size: labelFontSize)
        totalLabel.textColor = UIColor.whiteColor()
        display.addSubview(totalLabel)
        
        totalTextField = UITextField(frame: CGRectMake(margin + labelWidth, thirdSpace, screenWidth - labelWidth - margin * 2, numHeight))
        totalTextField.text = ""
        totalTextField.font = UIFont(name: "HelveticaNeue-UltraLight", size: numFontSize)
        totalTextField.textColor = UIColor.whiteColor()
        totalTextField.textAlignment = .Right
        totalTextField.userInteractionEnabled = false
        totalTextField.adjustsFontSizeToFitWidth = true
        display.addSubview(totalTextField)
        
        
        // add display UIView to the screen
        self.view.addSubview(display)
    }
    
    // draw the controls section of the UI
    func drawControls() {
        // instantiate the controls UIView
        controls = UIView(frame: CGRectMake(0, displayHeight, screenWidth, controlsHeight)) // x, y, width, height
        controls.backgroundColor = UIColor.whiteColor()
        
        
        // draw the horizontal divider line
        var divider = UIView(frame: CGRectMake(0, controlsHeight / 2, screenWidth, dividerSize))
        divider.backgroundColor = UIColor.blackColor()
        controls.addSubview(divider)
        
        
        // draw the bill splitter elements
        splitsLabel = UILabel(frame: CGRectMake(6, 12, 100, 20))
        splitsLabel.text = "Split 1 way"
        controls.addSubview(splitsLabel)
        
        stepper = UIStepper(frame: CGRectMake(screenWidth - 100, 7, 0, 0))
        stepper.tintColor = moneyColor
        stepper.minimumValue = 1
        stepper.maximumValue = 99
        stepper.addTarget(self, action: "splitChanged:", forControlEvents: .ValueChanged)
        controls.addSubview(stepper)
        
        
        // draw the tip percentage changer elements
        sliderLabel = UILabel(frame: CGRectMake(6, 55, 66, 20))
        sliderLabel.text = "Tip 20%"
        controls.addSubview(sliderLabel)
        
        slider = UISlider(frame: CGRectMake(82, 50, screenWidth - 88, 29))
        slider.minimumValue = 0.0
        slider.maximumValue = 0.3
        slider.continuous = true
        slider.tintColor = moneyColor
        slider.value = 0.2
        slider.addTarget(self, action: "tipChanged:", forControlEvents: .ValueChanged)
        controls.addSubview(slider)
        
        
        // add controls UIView to the screen
        self.view.addSubview(controls)
    }
    
    // draw the keypad section of the UI
    func drawKeypad() {
        // instantiate the keypad UIView
        keypad = UIView(frame: CGRectMake(0, displayHeight + controlsHeight, screenWidth, keypadHeight))
        
        
        // calculate values for drawing elements
        var keyWidth: CGFloat = screenWidth / 4
        var keyHeight: CGFloat = keypadHeight / 4
        var numFontSize: CGFloat = keyHeight / 2.25
        var charFontSize: CGFloat = keyHeight / 3.25
        var keys = ["7", "8", "9", "4", "5", "6", "1", "2", "3"]
        
        
        // draw numeric keys
        var count: CGFloat = 0
        for key in keys {
            var button = UIButton(frame: CGRectMake(count % 3 * keyWidth, CGFloat(Int(count / 3)) * keyHeight, keyWidth, keyHeight))
            button.setTitle(key, forState: UIControlState.Normal)
            button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: numFontSize)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.tag = key.toInt()!
            
            button.addTarget(self, action: "anyButtonPress:", forControlEvents: UIControlEvents.TouchDown)
            button.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
            button.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchDragOutside)
            button.addTarget(self, action: "numButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
            
            keypad.addSubview(button)
            
            count++
        }
        
        
        // draw the zero key
        var zero = UIButton(frame: CGRectMake(0, keypadHeight - keyHeight, keyWidth * 2, keyHeight))
        zero.setTitle("0", forState: UIControlState.Normal)
        zero.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: numFontSize)
        zero.titleEdgeInsets = UIEdgeInsetsMake(0.0, -keyWidth, 0.0, 0.0)
        zero.backgroundColor = UIColor.whiteColor()
        zero.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        zero.tag = 0
        
        zero.addTarget(self, action: "anyButtonPress:", forControlEvents: UIControlEvents.TouchDown)
        zero.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        zero.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchDragOutside)
        zero.addTarget(self, action: "numButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        
        keypad.addSubview(zero)
        
        
        // draw the decimal key
        var decimal = UIButton(frame: CGRectMake(keyWidth * 2, keypadHeight - keyHeight, keyWidth, keyHeight))
        decimal.setTitle(".", forState: UIControlState.Normal)
        decimal.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: charFontSize)
        decimal.backgroundColor = UIColor.whiteColor()
        decimal.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        decimal.tag = 11
        
        decimal.addTarget(self, action: "anyButtonPress:", forControlEvents: UIControlEvents.TouchDown)
        decimal.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        decimal.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchDragOutside)
        decimal.addTarget(self, action: "decimalButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        
        keypad.addSubview(decimal)
        
        
        // draw the C key
        var clear = UIButton(frame: CGRectMake(keyWidth * 3, 0, keyWidth, keyHeight * 2))
        clear.setTitle("C", forState: UIControlState.Normal)
        clear.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: charFontSize)
        clear.backgroundColor = lightGrayColor
        clear.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        clear.tag = 12
        
        clear.addTarget(self, action: "anyButtonPress:", forControlEvents: UIControlEvents.TouchDown)
        clear.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        clear.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchDragOutside)
        clear.addTarget(self, action: "clearButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        
        keypad.addSubview(clear)
        
        
        // draw the Del key
        var delete = UIButton(frame: CGRectMake(keyWidth * 3, keyHeight * 2, keyWidth, keyHeight * 2))
        delete.setTitle("Del", forState: UIControlState.Normal)
        delete.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: charFontSize)
        delete.backgroundColor = lightGrayColor
        delete.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        delete.tag = 13
        
        delete.addTarget(self, action: "anyButtonPress:", forControlEvents: UIControlEvents.TouchDown)
        delete.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        delete.addTarget(self, action: "animateButtonRelease:", forControlEvents: UIControlEvents.TouchDragOutside)
        delete.addTarget(self, action: "deleteButtonRelease:", forControlEvents: UIControlEvents.TouchUpInside)
        
        keypad.addSubview(delete)
        
        
        // add dividing lines to give keys distinct boundaries
        var dividers: [[CGFloat]] = [[0, 0, screenWidth, dividerSize], [0, keyHeight, screenWidth - keyWidth, dividerSize], [0, keyHeight * 2, screenWidth, dividerSize], [0, keyHeight * 3, screenWidth - keyWidth, dividerSize], [keyWidth, 0, dividerSize, keyHeight * 3], [keyWidth * 2, 0, dividerSize, keypadHeight], [keyWidth * 3, 0, dividerSize, keypadHeight]]
        for coords in dividers {
            var divider = UIView(frame: CGRectMake(coords[0], coords[1], coords[2], coords[3]))
            divider.backgroundColor = UIColor.blackColor()
            keypad.addSubview(divider)
        }
        
        
        // add keypad UIView to the screen
        self.view.addSubview(keypad)
    }
    
}
