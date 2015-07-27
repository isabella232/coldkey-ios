//
//  CKRecoveredKeysViewController.h
//  ColdKey
//

#import <UIKit/UIKit.h>

@class CKKeyInfo;

@interface CKKeyViewController : UIViewController

@property (nonatomic, readwrite, assign) BOOL isPrivate;

- (instancetype)initWithTitle:(NSString *)title key:(NSString *)key;

@end
