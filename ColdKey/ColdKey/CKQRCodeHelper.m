#import "CKQRCodeHelper.h"

@implementation CKQRCodeHelper

+ (CIImage *)createQRForString:(NSString *)qrString
{
  // Need to convert the string to a UTF-8 encoded NSData object
  NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
  
  // Create the filter
  CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
  // Set the message content and error-correction level
  [qrFilter setValue:stringData forKey:@"inputMessage"];
  [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
  
  // Send the image back
  return qrFilter.outputImage;
}

+ (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
  // Render the CIImage into a CGImage
  CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
  
  // Now we'll rescale using CoreGraphics
  UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
  CGContextRef context = UIGraphicsGetCurrentContext();
  // We don't want to interpolate (since we've got a pixel-correct image)
  CGContextSetInterpolationQuality(context, kCGInterpolationNone);
  CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
  // Get the image out
  UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  // Tidy up
  UIGraphicsEndImageContext();
  CGImageRelease(cgImage);
  // Need to set the image orientation correctly
  UIImage *flippedImage = [UIImage imageWithCGImage:[scaledImage CGImage]
                                              scale:scaledImage.scale
                                        orientation:UIImageOrientationDownMirrored];
  
  return flippedImage;
}

@end
