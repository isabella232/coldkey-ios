//
//  ColdKeyViewController.swift
//  ColdKeySwift
//
//  Created by Huang Yu on 8/3/15.
//  Copyright (c) 2015 BitGo, Inc. All rights reserved.
//

import UIKit

class ColdKeyViewController: UIViewController, UIAlertViewDelegate {
    
    var hasBackButton: Bool = true
    var hidesBackButton: Bool = true
    var hasLogo: Bool = true
    var noScreenshot: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if hasBackButton {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                style: UIBarButtonItemStyle.Plain,
                target: nil, action: nil)
            self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        }
        if hidesBackButton {
            self.navigationItem.hidesBackButton = true
        }
        if hasLogo {
            self.navigationItem.titleView = UIImageView(image: UIImage(named: "shield_logo_white"))
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if noScreenshot {
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: Selector("didTakeScreenshot"),
                name: UIApplicationUserDidTakeScreenshotNotification,
                object: nil
            )
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if noScreenshot {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
    
    deinit {
        if noScreenshot {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
    
    func didTakeScreenshot() {
        println("did take screenshot")
        UIAlertView(type: .TakeScreenshot, delegate: self).show()
    }
    
    // MARK: - UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.title == AlertTitle.Warning.rawValue {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}
