//
//  AlertManager.swift
//  ColdKeySwift
//
//  Created by Huang Yu on 8/6/15.
//  Copyright (c) 2015 BitGo, Inc. All rights reserved.
//

import UIKit

public protocol SharingActivityMessage {
    var shareMessage: String { get }
}

public enum SharingActivity: SharingActivityMessage {
    case GenerateXPub(xpub: String)
    
    
    public var shareMessage: String {
        switch self {
        case .GenerateXPub(let xpub):
            return "I just generated a new Bitcoin key using BitGo KeyTool: \(xpub)"
        default:
            return "I just generated a new Bitcoin key using Bitgo KeyTool"
        }
    }
}

public enum AlertTitle: String {
    case Warning = "Warning"
    case StartOver = "Start Over"
    case Accept = "Did You Write It Down?"
    case IncorrectPhrase = "Incorrect Phrase"
    case TooShort = "Too Short"
    case TooLong = "Too Long"
    case PairingSucceeded = "Pairing Succeeded"
    case PairingFailed = "Pairing Failed"
}

public enum AlertMessage: String {
    case Screenshot = "Taking a screenhost compromises the security of this key since other apps may access photos on your device."
    case StartOver = "Are you sure you want to discard your progress and start over?"
    case Accept = "The next step will require you to re-enter this phrase. Please ensure you have copied it down accurately."
    case IncorrectPhrase = "The key recovery phrase you entered does not match. Please be sure you've entered it exactly."
    case TooShort = "The key recovery phrase you entered is too short. Please try again."
    case TooLong = "The key recovery phrase you entered is too long. Please try again."
    case PairingSucceeded = "Your key has been successfully paired with your BitGo wallet"
    case PairingFailed = "Something went wrong. Please try again."
}

public enum CancelButtonTitle: String {
    case Cancel = "Cancel"
    case No = "No"
}

public enum OtherButtonTitle: String {
    case OK = "OK"
    case StartOver = "Start Over"
    case Yes = "Yes"
}

class AlertManager: NSObject {
    static let sharedManager = AlertManager()
    var alertView: UIAlertView? = nil
}

extension UIAlertView {
    convenience init(
        title: AlertTitle,
        message: AlertMessage,
        cancelButtonTitle: CancelButtonTitle?,
        otherButtonTitle: OtherButtonTitle,
        delegate: UIAlertViewDelegate?)
    {
        self.init(
            title: title.rawValue,
            message: message.rawValue,
            delegate: delegate,
            cancelButtonTitle: cancelButtonTitle?.rawValue,
            otherButtonTitles: otherButtonTitle.rawValue
        )
        AlertManager.sharedManager.alertView?.dismissWithClickedButtonIndex(0, animated: false)
        AlertManager.sharedManager.alertView = self
    }
}

public enum AlertType {
    case
    TakeScreenshot,
    PairingSucceeded,
    PairingFailed,
    TooShort,
    TooLong,
    IncorrectPhrase,
    Accept,
    StartOver
}

extension UIAlertView {
    convenience init(type: AlertType, delegate: UIAlertViewDelegate?) {
        var alertView: UIAlertView
        switch type {
        case .TakeScreenshot:
            self.init(
                title: .Warning,
                message: .Screenshot,
                cancelButtonTitle: nil,
                otherButtonTitle: .StartOver,
                delegate: delegate
            )
        case .PairingSucceeded:
            self.init(
                title: .PairingSucceeded,
                message: .PairingSucceeded,
                cancelButtonTitle: nil,
                otherButtonTitle: .OK,
                delegate: delegate
            )
        case .PairingFailed:
            self.init(
                title: .PairingFailed,
                message: .PairingFailed,
                cancelButtonTitle: nil,
                otherButtonTitle: .OK,
                delegate: delegate
            )
        case .TooLong:
            self.init(
                title: .TooLong,
                message: .TooLong,
                cancelButtonTitle: nil,
                otherButtonTitle: .OK,
                delegate: delegate
            )
        case .TooShort:
            self.init(
                title: .TooShort,
                message: .TooShort,
                cancelButtonTitle: nil,
                otherButtonTitle: .OK,
                delegate: delegate
            )
        case .IncorrectPhrase:
            self.init(
                title: .IncorrectPhrase,
                message: .IncorrectPhrase,
                cancelButtonTitle: nil,
                otherButtonTitle: .OK,
                delegate: delegate
            )
        case .Accept:
            self.init(
                title: .Accept,
                message: .Accept,
                cancelButtonTitle: .No,
                otherButtonTitle: .Yes,
                delegate: delegate
            )
        case .StartOver:
            self.init(
                title: .StartOver,
                message: .StartOver,
                cancelButtonTitle: .Cancel,
                otherButtonTitle: .StartOver,
                delegate: delegate
            )
        default:
            self.init(
                title: .Warning,
                message: .PairingFailed,
                cancelButtonTitle: nil,
                otherButtonTitle: .OK,
                delegate: nil
            )
        }
    }
}
