//
//  UIImage+Color.m
//  ColdKey
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
  UIGraphicsBeginImageContext(size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetFillColorWithColor(context, color.CGColor);
  CGContextFillRect(context, (CGRect){.size = size});
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
  return [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
}

@end
