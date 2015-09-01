//
//  RandomViewController.swift
//  ColdKeySwift
//
//  Created by Huang Yu on 8/12/15.
//  Copyright (c) 2015 BitGo, Inc. All rights reserved.
//

import UIKit

class RandomViewController: ColdKeyViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressStartOver(sender: AnyObject) {
        UIAlertView(type: .StartOver, delegate: self).show()
    }
    
    override func alertView(
        alertView: UIAlertView,
        clickedButtonAtIndex buttonIndex: Int)
    {
        if alertView.title == AlertTitle.StartOver.rawValue {
            if buttonIndex == 1 {
                self.performSegueWithIdentifier(
                    "backToRootViewControllerFromRandomSegue",
                    sender: self
                )
            }
        } else {
            super.alertView(alertView, clickedButtonAtIndex: buttonIndex)
        }
    }
}
