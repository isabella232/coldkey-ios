//
//  CKAppearanceHelper.h
//  ColdKey
//

#import <Foundation/Foundation.h>

//RGB color macro
#define HEXColor(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

NSString *TitleText();

UIFont *TitleFont();

UIImageView *TitleImageView();

CGFloat ButtonHeight();

CGFloat QRCodeSize();

// Colors

UIColor *BackgroundColor();
UIColor *PrimaryTintColor();
UIColor *BitGoLightBlueColor();
UIColor *BitGoDarkBlueColor();
UIColor *GrayTextColor();
UIColor *ButtonDisabledColor();

// UI Elements

UIButton *PrimaryButton();
UIButton *SecondaryButton();
UIButton *LinkButton();
UILabel *TitleLabel();
UILabel *InstructionLabel();
UITextView *KeyLabel();

// Padding

CGFloat TitleOriginY();
CGFloat XMargin();
CGFloat PrimarySecondaryButtonPadding();
CGFloat ButtonBottomPadding();
