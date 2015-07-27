//
//  CKStringHelper.m
//  ColdKey
//

#import "CKKeyInfoHelper.h"

#import <CoreBitcoin/CoreBitcoin.h>

#import "CKKeyInfo.h"

#import "NYMnemonic.h"

CKKeyInfo *KeyInfofromMnemonic(NSString *mnemonic)
{
  NSString *seedHEX = [NYMnemonic deterministicSeedStringFromMnemonicString:mnemonic
                                                                 passphrase:@""
                                                                   language:@"english"];
  NSData* seed = BTCDataWithHexCString([seedHEX UTF8String]);
  
  BTCKeychain *keychain = [[BTCKeychain alloc] initWithSeed:seed];
  NSString *publicKey = BTCBase58CheckStringWithData([keychain extendedPublicKeyData]);
  NSString *privateKey = BTCBase58CheckStringWithData([keychain extendedPrivateKeyData]);
  
  CKKeyInfo *keyInfo = [[CKKeyInfo alloc] initWithMnemonic:mnemonic publicKey:publicKey privateKey:privateKey];
  return keyInfo;
}