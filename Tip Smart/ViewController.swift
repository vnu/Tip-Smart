//
//  ViewController.swift
//  Tip Smart
//
//  Created by Vinu Charanya on 12/6/15.
//  Copyright © 2015 vnu. All rights reserved.
//

import UIKit
import Foundation

extension Double {
    func format(f: Double) -> String {
        return String(format: "%\(f)f", self)
    }
}

class ViewController: UIViewController {

    //Fields
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var smartTipView: UIView!
    @IBOutlet weak var serviceTipControl: UISegmentedControl!
    
    @IBOutlet weak var tipField: UITextField!
    @IBOutlet weak var tipAmountField: UITextField!
    @IBOutlet weak var billTotalField: UILabel!
    
    // Split Bill
    @IBOutlet weak var splitSwitchView: UIView!
    @IBOutlet weak var splitBillSwitch: UISwitch!
    @IBOutlet weak var splitBillView: UIView!
    @IBOutlet weak var splitIntoField: UITextField!
    
    //Check Values
    
    
    @IBOutlet weak var splitBillLabel: UILabel!
    @IBOutlet weak var splitTipLabel: UILabel!
    @IBOutlet weak var splitTotalLabel: UILabel!
    @IBOutlet weak var splitOverallTipLabel: UILabel!
    @IBOutlet weak var splitOverallTotalLabel: UILabel!
    var tipPercentages = [15.0, 18.0, 20.0]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipField.text = "\(tipPercentages[0])"
    }
    
    func updateUserDefaults(){
        let defaults = NSUserDefaults.standardUserDefaults()
        let tipIndex = defaults.integerForKey("ServiceTipIndex")
        serviceTipControl.selectedSegmentIndex = tipIndex
        tipPercentages = [defaults.doubleForKey("SetSadTip"),defaults.doubleForKey("SetMehTip"),defaults.doubleForKey("SetHappyTip")]
        tipField.text = "\(tipPercentages[tipIndex])"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        billField.becomeFirstResponder()
        updateUserDefaults()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Smart Tip View
    func hideSmartTipView(){
        UIView.animateWithDuration(0.3, delay: 0.2, options: .CurveEaseInOut, animations: {
            var smartTipViewFrame =  self.smartTipView.frame
            smartTipViewFrame.origin.y = 400
            self.smartTipView.frame = smartTipViewFrame
            }, completion: { finished in
                print("Tip options hidden!")
                self.smartTipView.hidden = true
        })
    }
    
    func showSmartTipView(){
        smartTipView.hidden = false
        UIView.animateWithDuration(1.0, delay: 0.2, options: .CurveEaseInOut, animations: {
            print("\(self.smartTipView.frame)")
            
            var smartTipViewFrame =  self.smartTipView.frame
            smartTipViewFrame.origin.y = 130
            self.smartTipView.frame = smartTipViewFrame
            }, completion: { finished in
                print("Tip options opened!")
        })
    }
    
    
    //Bill Calculations
    func calculateValues(tipValue:Double=0.00,tipAmount:Double=0.00,totalAmount:Double=0.00) ->
        (tipValue:Double,tipAmount:Double,totalAmount:Double)
    {
        let billAmount = (billField.text! as NSString).doubleValue
//        splitBillLabel.text = "\(billAmount)"
        if(billAmount < 0){
            return(0,0,0)
        }
        var tipValue = tipValue
        var tipAmount = tipAmount
        var totalAmount = totalAmount
        if (tipAmount > 0){
            tipValue = (tipAmount * 100) / billAmount
            totalAmount = billAmount + tipAmount
        }else if(totalAmount > 0){
            tipAmount = totalAmount - billAmount
            tipValue = (tipAmount * 100) / billAmount
        }else if(tipValue > 0){
            tipAmount = (billAmount * tipValue/100)
            totalAmount = billAmount + tipAmount
        }
        return(tipValue, tipAmount, totalAmount);
    }
    
    func updateTotal(){
        let tipValue = (tipField.text! as NSString).doubleValue
        let billValues = calculateValues(tipValue)
        tipAmountField.text = "\(billValues.tipAmount.format(0.2))"
        billTotalField.text = "\(billValues.totalAmount.format(0.2))"
        updateSplitBillValues()
    }
    
    
    //User actions
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    @IBAction func onBillEditingChanged(sender: AnyObject) {
        let billAmount = (billField.text! as NSString).doubleValue
        if(billAmount > 0){
            showSmartTipView()
            updateTotal()
        }else{
            hideSmartTipView()
        }

    }
    
    @IBAction func serviceTipControlChanged(sender: AnyObject) {
        let selectedIndex = serviceTipControl.selectedSegmentIndex
        if(selectedIndex < 3){
            view.endEditing(true)
            tipField.text = "\(tipPercentages[selectedIndex])"
            updateTotal()
        }else{
            tipField.becomeFirstResponder()
        }
    }
    
    //Round up
    func UpdateOnTotalChanges(){
        let totalAmount = (billTotalField.text! as NSString).doubleValue
        let billValues = calculateValues(totalAmount: totalAmount)
        tipField.text = String(format:"%.2f", billValues.tipValue)
        tipAmountField.text = String(format:"%.2f", billValues.tipAmount)
        updateSplitBillValues()
    }
    

    
    @IBAction func totalRoundUpPressed(sender: AnyObject) {
        let totalValue = (billTotalField.text! as NSString).doubleValue
        billTotalField.text = "\(floor(totalValue)+1)"
        UpdateOnTotalChanges()
    }
    
    @IBAction func totalRoundDownPressed(sender: AnyObject) {
        let totalValue = (billTotalField.text! as NSString).doubleValue
        billTotalField.text = "\(ceil(totalValue)-1)"
        UpdateOnTotalChanges()
    }
    
    // Split Bill
    
    func hideSplitBillView(){
        if(splitBillSwitch.on){
            splitBillSwitch.on = false
        }
        UIView.animateWithDuration(0.5, delay: 0.2, options: .CurveEaseInOut, animations: {
            
            var splitSwitchViewFrame = self.splitSwitchView.frame
            splitSwitchViewFrame.origin.y = 145
            
            var splitBillViewFrame =  self.splitBillView.frame
            splitBillViewFrame.origin.y =             splitSwitchViewFrame.origin.y + splitSwitchViewFrame.size.height
            
            self.splitSwitchView.frame = splitSwitchViewFrame
            self.splitBillView.frame = splitBillViewFrame
            
            }, completion: { finished in
                print("Split View closed!")
                self.splitBillView.hidden = true
        })

    }

    func updateSplit(byValue: Int){
        let splitInto = Int(splitIntoField.text!)
        if(byValue > 0 || (byValue < 0 && splitInto > 1)){
            splitIntoField.text = "\(splitInto! + byValue)"
        }
        updateSplitBillValues()
    }
    
    
    func updateSplitBillValues(){
        if(splitBillSwitch.on){
        let splitInto = (splitIntoField.text! as NSString).doubleValue
        let billAmount = (billField.text! as NSString).doubleValue / splitInto
        let tipAmount = (tipAmountField.text! as NSString).doubleValue / splitInto
        let totalAmount = billAmount + tipAmount
        splitBillLabel.text = "\(billAmount.format(0.2))"
        splitTipLabel.text = "\(tipAmount.format(0.2))"
        splitTotalLabel.text = "\(totalAmount.format(0.2))"
        splitOverallTipLabel.text = tipAmountField.text
        splitOverallTotalLabel.text = billTotalField.text
        }
    }
    
    func showSplitBillView(){
        view.endEditing(true)
        splitBillView.hidden = false
        updateSplitBillValues()
        UIView.animateWithDuration(1.0, delay: 0.2, options: .CurveEaseInOut, animations: {
            
            var splitSwitchViewFrame = self.splitSwitchView.frame
            splitSwitchViewFrame.origin.y = 95
            
            var splitBillViewFrame =  self.splitBillView.frame
            splitBillViewFrame.origin.y =             splitSwitchViewFrame.origin.y + splitSwitchViewFrame.size.height
            
            self.splitSwitchView.frame = splitSwitchViewFrame
            self.splitBillView.frame = splitBillViewFrame
            
            }, completion: { finished in
                print("Split View opened!")
        })
    }
    
    @IBAction func splitSwitchToggled(sender: AnyObject) {
        if(splitBillSwitch.on){
           showSplitBillView()
        }else{
            hideSplitBillView()
        }
    }
    @IBAction func incrSplitButtonPressed(sender: AnyObject) {
        updateSplit(1)
    }
    
    @IBAction func decrSplitButtonPressed(sender: AnyObject) {
        updateSplit(-1)
    }
}

