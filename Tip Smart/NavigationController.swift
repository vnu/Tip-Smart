//
//  NavigationController.swift
//  Tip Smart
//
//  Created by Vinu Charanya on 12/6/15.
//  Copyright © 2015 vnu. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = UIColor.whiteColor()
        let titleAttributes = [
            NSForegroundColorAttributeName: UIColor.cyanColor(),
            NSFontAttributeName: UIFont(name: "Chalkduster", size: 20)!
        ]
        self.navigationBar.titleTextAttributes = titleAttributes
    }
}
