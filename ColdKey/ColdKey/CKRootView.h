//
//  CKRootView.h
//  ColdKey
//

#import <UIKit/UIKit.h>

@class CKRootView;

@protocol CKRootViewDelegate <NSObject>

- (void)rootViewDidPressGenerate:(UIView *)rootView;
- (void)rootViewDidPressRecover:(UIView *)rootView;
- (void)rootViewDidPressHelp:(UIView *)rootView;

@end

@interface CKRootView : UIView

@property (nonatomic, readwrite, assign) id<CKRootViewDelegate> delegate;

- (void)showLoading;
- (void)hideLoading;

@end
