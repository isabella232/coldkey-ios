//
//  CKKeyInfo.h
//  ColdKey
//

#import <Foundation/Foundation.h>

@interface CKKeyInfo : NSObject

@property (nonatomic, readonly, copy) NSString *mnemonic;
@property (nonatomic, readonly, copy) NSString *publicKey;
@property (nonatomic, readonly, copy) NSString *privateKey;

- (instancetype)initWithMnemonic:(NSString *)mnemonic
                       publicKey:(NSString *)publicKey
                      privateKey:(NSString *)privateKey;

@end
