//
//  CKNewSeedView.h
//  ColdKey
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CKSeedViewState)
{
  CKSeedViewStateNew = 0,
  CKSeedViewStateConfirm
};

typedef NS_ENUM(NSUInteger, CKSeedViewBorderState)
{
  CKSeedViewBorderStateDefault = 0,
  CKSeedViewBorderStateError,
  CKSeedViewBorderStateMatched,
};

@class CKNewSeedView;

@protocol CKNewSeedViewDelegate <NSObject>

- (void)newSeedViewDidPressStartOver:(CKNewSeedView *)view;

- (void)newSeedViewDidPressAccept:(CKNewSeedView *)view;

- (void)newSeedView:(CKNewSeedView *)view didPressConfirmWithString:(NSString *)string;

- (void)newSeedView:(CKNewSeedView *)view didChangeText:(NSString *)text;

@end

@interface CKNewSeedView : UIView

@property (nonatomic, readwrite, weak) id<CKNewSeedViewDelegate> delegate;

@property (nonatomic, readonly, assign) CKSeedViewState state;

- (void)setMnemonic:(NSString *)mnemonic;

- (void)setViewState:(CKSeedViewState)state animated:(BOOL)animated;

- (void)setConfirmButtonEnabled:(BOOL)enabled;

- (void)setBorderState:(CKSeedViewBorderState)state;


@end

