//
//  KeyInfo.swift
//  ColdKey
//
//  Created by Huang Yu on 7/29/15.
//  Copyright (c) 2015 Huang Yu. All rights reserved.
//

import UIKit

class KeyInfo: NSObject {
    
    var mnemonic: BTCMnemonic?
    var publicKey: NSString! = ""
    var privateKey: NSString! = ""
    
    func mnemonicString() -> String {
        if let mn = self.mnemonic {
            var array = mn.words as! [String]
            return " ".join(array)
        }
        return ""
    }
    
    override init() {
        super.init()
    }
    
    init(mnemonic: BTCMnemonic!, publicKey: NSString, privateKey: NSString) {
        self.mnemonic = mnemonic
        self.publicKey = publicKey
        self.privateKey = privateKey
        super.init()
    }
    
    convenience init(data mnData: NSData) {
        self.init(
            mnemonic: BTCMnemonic(
                entropy: mnData,
                password: "",
                wordListType: BTCMnemonicWordListType.English
            )
        )
    }
    
    convenience init(words mnWords: [String]) {
        self.init(
            mnemonic: BTCMnemonic(
                words: mnWords,
                password: "",
                wordListType: BTCMnemonicWordListType.English
            )
        )
    }
    
    convenience init(mnemonic: BTCMnemonic?) {
        var publicKey: String
        var privateKey: String
        if let mn = mnemonic {
            var keychain = mn.keychain
            publicKey = keychain.extendedPublicKey
            privateKey = keychain.extendedPrivateKey
        } else {
            publicKey = "Invalid Key Recovery Phrase"
            privateKey = "Invalid Key Recovery Phrase"
        }
        self.init(
            mnemonic: mnemonic,
            publicKey: publicKey,
            privateKey: privateKey
        )
    }
}
