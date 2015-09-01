//
//  SuccessViewController.swift
//  ColdKeySwift
//
//  Created by Huang Yu on 7/29/15.
//  Copyright (c) 2015 BitGo, Inc. All rights reserved.
//

import UIKit

class SuccessViewController: ColdKeyViewController, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        noScreenshot = false
    }

    @IBAction func sharePublicKey(sender: AnyObject) {
        let xpub = KeyInfoManager.sharedManager.keyInfo.publicKey as String
        var items = [AnyObject]()
        let message = SharingActivity.GenerateXPub(xpub: xpub).shareMessage
        items.append(message)
        if let qrcode = KeyInfoManager.sharedManager.publicKeyQRCode {
            items.append(qrcode)
        }
        var activityViewController = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            // iOS8 iPads
            popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem
        }
        self.navigationController?.presentViewController(activityViewController,
            animated: true) { () -> Void in
                println("presented activities")
        }
    }
    
    @IBAction func showKey(sender: AnyObject) {
        self.performSegueWithIdentifier(
            "showQRCodeViewControllerSegue",
            sender: sender)
    }
    
    @IBAction func backFromQRCode(segue: UIStoryboardSegue) {
        println("back from qrcode view")
    }
    
    @IBAction func backFromScan(segue: UIStoryboardSegue) {
        println("back from scanning")
    }
    
    @IBAction func pressStartOver(sender: AnyObject) {
        UIAlertView(type: .StartOver, delegate: self).show()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier == "showQRCodeViewControllerSegue" {
            if sender != nil {
                if let destVC = segue.destinationViewController as? QRCodeViewController {
                    destVC.keyType = sender!.tag
                }
            }
        }
    }
    
    // MARK: - UIAlertViewDelegate
    
    override func alertView(
        alertView: UIAlertView,
        clickedButtonAtIndex buttonIndex: Int)
    {
        if alertView.title == AlertTitle.StartOver.rawValue {
            if buttonIndex == 1 {
                self.performSegueWithIdentifier(
                    "backToRootViewControllerFromSuccessSegue",
                    sender: self
                )
            }
        } else {
            super.alertView(alertView, clickedButtonAtIndex: buttonIndex)
        }
    }
}
