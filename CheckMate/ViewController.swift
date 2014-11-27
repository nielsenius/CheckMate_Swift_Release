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
    let lightGrayColor = UIColor(red: 225 / 256.0, green: 225 / 256.0, blue: 225 / 256.0, alpha: 1)
    let midGrayColor = UIColor(red: 192 / 256.0, green: 192 / 256.0, blue: 192 / 256.0, alpha: 1)
    
    let sym = ViewController.getCurrencySymbol()
    let sep = ViewController.getThousandsSeparator()
    
    let tockSound = ViewController.loadTockSound()
    
    let customView = UINib(nibName: "Custom", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as UIView
    
    var model = Model()
    
    //
    // IBOutlets
    //
    
    @IBOutlet var billTextField: UITextField!
    @IBOutlet var tipTextField: UITextField!
    @IBOutlet var totalTextField: UITextField!
    
    @IBOutlet var splitsTextField: UITextField!
    @IBOutlet var sliderTextField: UITextField!
    @IBOutlet var slider: UISlider!
    @IBOutlet var stepper: UIStepper!
    
    //
    // IBActions
    //
    
    @IBAction func splitChanged(sender: UIStepper) {
        model.splits = Int(sender.value)
        redrawDisplay()
    }
    
    @IBAction func tipChanged(sender: UISlider) {
        model.setPercent(round(sender.value * 100))
        redrawDisplay()
    }
    
    @IBAction func anyButtonPress(sender: UIButton) {
        if sender.tag == 12 || sender.tag == 13 {
            sender.backgroundColor = midGrayColor
        } else {
            sender.backgroundColor = lightGrayColor
        }
        playTockSound()
    }
    
    @IBAction func numButtonRelease(sender: UIButton) {
        model.appendNumToBill(String(sender.tag))
        animateButtonRelease(sender)
        redrawDisplay()
    }
    
    @IBAction func decimalButtonRelease(sender: UIButton) {
        model.appendSepToBill()
        animateButtonRelease(sender)
        redrawDisplay()
    }
    
    @IBAction func clearButtonRelease(sender: UIButton) {
        model.clearBill()
        animateButtonRelease(sender)
        redrawDisplay()
    }
    
    @IBAction func deleteButtonRelease(sender: UIButton) {
        model.deleteBill()
        animateButtonRelease(sender)
        redrawDisplay()
    }
    
    //
    // other functions
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // do any additional setup after loading the view
        redrawDisplay()
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

}

