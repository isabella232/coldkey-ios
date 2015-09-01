//
//  RootViewController.swift
//  ColdKey
//
//  Created by Huang Yu on 7/29/15.
//  Copyright (c) 2015 Huang Yu. All rights reserved.
//

import UIKit

class RootViewController: ColdKeyViewController, KeyInfoManagerDelegate {
    
    var keyInfoManager: KeyInfoManager = KeyInfoManager.sharedManager

    override func viewDidLoad() {
        super.viewDidLoad()
        noScreenshot = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.stopAnimating()
        activityLabel.hidden = true
        descriptionLabel.hidden = false
        self.keyInfoManager.reset()
        self.createKeyButton.enabled = true
        self.recoverKeyButton.enabled = true
    }

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var createKeyButton: UIButton!
    @IBOutlet var recoverKeyButton: UIButton!
    
    @IBAction func createNewKey(sender: AnyObject) {
        self.keyInfoManager.delegate = self
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        descriptionLabel.hidden = true
        activityLabel.text = "Gathering randomness..."
        activityLabel.hidden = false
        self.createKeyButton.enabled = false
        self.recoverKeyButton.enabled = false
        self.keyInfoManager.generate()
    }

    @IBAction func recoverKey(sender: AnyObject) {
        self.performSegueWithIdentifier("showRecoverViewControllerSegue",
            sender: self)
    }
    
    // MARK: - Navigation
    
    @IBAction func startOver(segue: UIStoryboardSegue) {
        println("start over")
    }
    
    // Mark: - KeyInfoManagerDelegate 
    
    func didGenerateKeyInfo() {
        var msecs: UInt64 = 500
        var delay = dispatch_time(DISPATCH_TIME_NOW, Int64(msecs * NSEC_PER_MSEC))
        dispatch_after(delay, dispatch_get_main_queue()) { () -> Void in
            self.activityLabel.text = "Generating key..."
            var delay = dispatch_time(DISPATCH_TIME_NOW, Int64(msecs * NSEC_PER_MSEC))
            dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("showKeyViewControllerSegue", sender: self)
            })
        }
    }
    
    func didResetKeyInfo() {
        println("did reset keyinfo")
    }
}
