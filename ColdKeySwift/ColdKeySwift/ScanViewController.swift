//
//  ScanViewController.swift
//  ColdKeySwift
//
//  Created by Huang Yu on 7/30/15.
//  Copyright (c) 2015 BitGo, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: ColdKeyViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate {
    
    var session: AVCaptureSession?

    @IBOutlet weak var previewView: UIView!
    @IBOutlet var noVideoCamLabel: UILabel!
    @IBOutlet var instructionLabel: UILabel!
    
    override func viewDidLoad() {
        self.hidesBackButton = false
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.noVideoCamLabel.hidden = true
        self.instructionLabel.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var videoDeivces = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        
        if videoDeivces.count > 0 {
            self.noVideoCamLabel.hidden = true
            self.instructionLabel.hidden = false
            let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(device, error: nil)
            let output = AVCaptureMetadataOutput()
            self.session = AVCaptureSession()
            if let session = self.session {
                session.addInput(input as! AVCaptureDeviceInput)
                session.addOutput(output)
                output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
                output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
                
                var preview = AVCaptureVideoPreviewLayer(session: session)
                preview.frame = self.previewView.bounds
                preview.videoGravity = AVLayerVideoGravityResizeAspectFill
                
                
                preview.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                self.previewView.layer.insertSublayer(preview, atIndex: 0)
                
                session.startRunning()
            }
        } else {
            self.noVideoCamLabel.hidden = false
            self.instructionLabel.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let session = self.session {
            session.stopRunning()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        if let session = self.session {
            session.stopRunning()
        }
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for current in metadataObjects {
            if let validObject = current as? AVMetadataMachineReadableCodeObject {
                self.session?.stopRunning()
                var jsonError: NSError?
                if let
                    scannedData = validObject.stringValue.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false),
                    json = NSJSONSerialization.JSONObjectWithData(scannedData, options: nil, error: &jsonError) as? [String:AnyObject]
                {
                    let secret = json["s"] as? String ?? ""
                    let server = json["e"] as? String ?? "dev"
                    let version = json["v"] as? Int ?? 0
                    
                    if version != KeyInfoManager.qrCodeVersion {
                        UIAlertView(type: .PairingFailed, delegate: self).show()
                        break
                    }

                    let baseUrl: KeyInfoBaseUrl = KeyInfoBaseUrl(rawValue: server) ?? .Dev
                    KeyInfoManager.sharedManager.baseUrl = baseUrl
                    KeyInfoManager.sharedManager.signingKey = secret
                    KeyInfoManager.sharedManager.postRequest({ (result, JSON, error) -> () in
                        if result {
                            UIAlertView(type: .PairingSucceeded, delegate: self).show()
                        } else {
                            UIAlertView(type: .PairingFailed, delegate: self).show()
                        }
                    })
                } else {
                    UIAlertView(type: .PairingFailed, delegate: self).show()
                }
            }
        }
    }
    
    // MARK: - UIAlertViewDelegate
    
    override func alertView(
        alertView: UIAlertView,
        clickedButtonAtIndex buttonIndex: Int)
    {
        if alertView.title == AlertTitle.PairingFailed.rawValue
        || alertView.title == AlertTitle.PairingSucceeded.rawValue {
            self.performSegueWithIdentifier("backFromScanViewControllerSegue", sender: self)
        } else {
            super.alertView(alertView, clickedButtonAtIndex: buttonIndex)
        }
    }
}
