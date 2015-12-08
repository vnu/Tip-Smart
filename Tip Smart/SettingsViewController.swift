//
//  SettingsViewController.swift
//  Tip Smart
//
//  Created by Vinu Charanya on 12/6/15.
//  Copyright © 2015 vnu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var serviceTipControl: UISegmentedControl!
    @IBOutlet weak var defaultSadTipField: UITextField!
    @IBOutlet weak var defaultMehTipField: UITextField!
    @IBOutlet weak var defaultHappyTipField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserDefaults()
        // Do any additional setup after loading the view.
    }
    
    func updateUserDefaults(){
        let defaults = NSUserDefaults.standardUserDefaults()
        let tipIndex = defaults.integerForKey("ServiceTipIndex")
        serviceTipControl.selectedSegmentIndex = tipIndex
        defaultSadTipField.text = "\(defaults.doubleForKey("SetSadTip"))"
        defaultMehTipField.text = "\(defaults.doubleForKey("SetMehTip"))"
        defaultHappyTipField.text = "\(defaults.doubleForKey("SetHappyTip"))"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onDonePressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func defaultServiceControlChanged(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(serviceTipControl.selectedSegmentIndex, forKey: "ServiceTipIndex")
        defaults.synchronize()
    }
    
    @IBAction func onEditingDefaultTips(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "HasCustomTips")
        defaults.setDouble((defaultSadTipField.text! as NSString).doubleValue, forKey: "SetSadTip")
        defaults.setDouble((defaultMehTipField.text! as NSString).doubleValue, forKey: "SetMehTip")
        defaults.setDouble((defaultHappyTipField.text! as NSString).doubleValue, forKey: "SetHappyTip")
        defaults.synchronize()
    }
    
//    defaults.setBool(false, forKey: "ShowSplitView")

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
