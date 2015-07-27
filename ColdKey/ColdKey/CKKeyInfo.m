//
//  CKKeyInfo.m
//  ColdKey
//

#import "CKKeyInfo.h"

@implementation CKKeyInfo

- (instancetype)initWithMnemonic:(NSString *)mnemonic
                       publicKey:(NSString *)publicKey
                      privateKey:(NSString *)privateKey
{
  if ((self = [super init])) {
    _mnemonic = [mnemonic copy];
    _publicKey = [publicKey copy];
    _privateKey = [privateKey copy];
  }
  return self;
}

@end
