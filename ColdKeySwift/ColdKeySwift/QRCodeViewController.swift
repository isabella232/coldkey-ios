//
//  QRCodeViewController.swift
//  ColdKeySwift
//
//  Created by Huang Yu on 7/29/15.
//  Copyright (c) 2015 BitGo, Inc. All rights reserved.
//

import UIKit

class QRCodeViewController: ColdKeyViewController {
    
    var keyType: Int = 0

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var qrCodeView: UIImageView!
    @IBOutlet var keyTextView: UITextView!

    override func viewDidLoad() {
        self.hidesBackButton = false
        super.viewDidLoad()
        var kiManager = KeyInfoManager.sharedManager
        var keyString: NSString
        var qrCode: UIImage?
        if self.keyType == 1 {
            self.noScreenshot = true
            self.titleLabel.text = "Private Key"
            keyString = kiManager.keyInfo.privateKey
            qrCode = kiManager.privateKeyQRCode
        } else {
            self.noScreenshot = false
            self.titleLabel.text = "Public Key"
            keyString = kiManager.keyInfo.publicKey
            qrCode = kiManager.publicKeyQRCode
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonSystemItem.Action,
                target: self,
                action: "sharePublicKey:")
        }
        self.keyTextView.text = keyString as String
        if let qr = qrCode {
            self.qrCodeView.image = qr
        }
    }
    
    func sharePublicKey(sender: AnyObject) {
        let xpub = KeyInfoManager.sharedManager.keyInfo.publicKey as String
        var items = [AnyObject]()
        let mgs: String = SharingActivity.GenerateXPub(xpub: xpub).shareMessage
        items.append(mgs)
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
}

