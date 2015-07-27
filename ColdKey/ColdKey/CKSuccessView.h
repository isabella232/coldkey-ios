//
//  CKSuccessView.h
//  ColdKey
//

#import <UIKit/UIKit.h>

@class CKSuccessView;

@protocol CKSuccessViewDelegate <NSObject>

- (void)successViewDidPressShowPublicKey:(CKSuccessView *)view;

- (void)successViewDidPressShowPrivateKey:(CKSuccessView *)view;

- (void)successViewDidPressLinkKey:(CKSuccessView *)view;

- (void)successViewDidPressStartOver:(CKSuccessView *)view;

@end

@interface CKSuccessView : UIView

@property (nonatomic, readwrite, weak) id<CKSuccessViewDelegate> delegate;

@end
