//
//  CKAppearanceHelper.m
//  ColdKey
//

#import "CKAppearanceHelper.h"

#import "UIImage+Color.h"

NSString *TitleText()
{
  return @"ColdKey";
}

UIFont *TitleFont()
{
  return [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
}

UIImageView *TitleImageView()
{
  UIImage *image = [UIImage imageNamed:@"bitgo-logo-white.png"];
  return [[UIImageView alloc] initWithImage:image];
}

CGFloat ButtonHeight()
{
  return 44.0;
}

CGFloat QRCodeSize()
{
  return 240.0;
}

# pragma mark - Colors

UIColor *GrayTextColor()
{
  //  return [UIColor colorWithRed:155.0/255 green:155.0/255 blue:155.0/255 alpha:1.0];
  return [UIColor colorWithRed:87.0/255 green:107.0/255 blue:129.0/255 alpha:1.0];
}

UIColor *BitGoLightBlueColor()
{
  return [UIColor colorWithRed:10.0/255.0 green:173.0/255.0 blue:219.0/255.0 alpha:1.0];
}

UIColor *BitGoDarkBlueColor()
{
  return HEXColor(0x024d68);
}

UIColor *BackgroundColor()
{
  return [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
}

UIColor *PrimaryTintColor()
{
  return BitGoLightBlueColor();
  //return [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1.0];
}

UIColor *ButtonPressedColor()
{
//  return [UIColor colorWithRed:47.0/255.0 green:103.0/255.0 blue:168.0/255.0 alpha:1.0];
  return [UIColor colorWithRed:42.0/255.0 green:147.0/255.0 blue:177.0/255.0 alpha:1.0];
}

UIColor *ButtonDisabledColor()
{
//  return [UIColor colorWithRed:152.0/255 green:171.0/255 blue:235.0/255 alpha:1.0];
  return [UIColor colorWithRed:126.0/255 green:199.0/255 blue:220.0/255 alpha:1.0];
}

#pragma  mark - UI Elements

UIButton *PrimaryButton()
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageWithColor:PrimaryTintColor()]
                    forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageWithColor:ButtonPressedColor()]
                    forState:UIControlStateHighlighted];
  [button setBackgroundImage:[UIImage imageWithColor:ButtonDisabledColor()]
                    forState:UIControlStateDisabled];
  [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   return button;
}

UIButton *SecondaryButton()
{
  UIColor *color = HEXColor(0x80A3AD); //HEXColor(0x858B8D)
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageWithColor:color]
                    forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageWithColor:ButtonPressedColor()]
                    forState:UIControlStateHighlighted];
  [button setBackgroundImage:[UIImage imageWithColor:ButtonDisabledColor()]
                    forState:UIControlStateDisabled];
  [button setTitleColor:HEXColor(0xffffff) forState:UIControlStateNormal];
  return button;
}

UIButton *LinkButton()
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.backgroundColor = [UIColor clearColor];
  [button setTitleColor:PrimaryTintColor() forState:UIControlStateNormal];
  [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
  [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
  button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
  return button;
}

UILabel *TitleLabel()
{
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.font = TitleFont();
  label.textColor = GrayTextColor();
  label.textAlignment = NSTextAlignmentCenter;
  return label;
}

UILabel *InstructionLabel()
{
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
  label.textColor = GrayTextColor();  label.textAlignment = NSTextAlignmentLeft;;
  label.numberOfLines = 0;
  return label;
}

UITextView *KeyLabel()
{
  UITextView *label = [[UITextView alloc] initWithFrame:CGRectZero];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
  label.textColor = GrayTextColor();
  label.textAlignment = NSTextAlignmentCenter;
  label.editable = NO;
  return label;
}

# pragma mark - Padding

CGFloat TitleOriginY()
{
  return 15.0;
}

CGFloat XMargin()
{
  return 20.0;
}

CGFloat PrimarySecondaryButtonPadding()
{
  return 5.0;
}

CGFloat ButtonBottomPadding()
{
  return 130.0;
}

