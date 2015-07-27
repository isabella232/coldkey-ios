//
//  CKSeedTextView.h
//  ColdKey
//

#import <UIKit/UIKit.h>

UIColor *SeedTextViewBorderColor();

@class CKSeedTextView;

@protocol CKSeedTextViewDelegate <NSObject>

- (void)textViewDidChange:(CKSeedTextView *)textView;

@end

@interface CKSeedTextView : UIView

@property (nonatomic, readwrite, weak) id<CKSeedTextViewDelegate> delegate;

@property (nonatomic, readwrite, copy) NSString *text;

- (void)setIsEditing:(BOOL)editing;

- (void)becomeFirstResponder;

- (void)setBorderColor:(UIColor *)color;

@end
