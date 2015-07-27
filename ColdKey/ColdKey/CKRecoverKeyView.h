//
//  CKRecoverSeedView.h
//  ColdKey
//

#import <UIKit/UIKit.h>

@class CKRecoverKeyView;

@protocol CKRecoverKeyViewDelegate <NSObject>

- (void)recoverKeyView:(CKRecoverKeyView *)view didPressRecover:(NSString *)seed;

@end

@interface CKRecoverKeyView : UIView

@property (nonatomic, readwrite, weak) id<CKRecoverKeyViewDelegate> delegate;

- (void)becomeFirstResponder;

@end