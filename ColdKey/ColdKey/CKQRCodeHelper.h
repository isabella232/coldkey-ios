#import <Foundation/Foundation.h>

@interface CKQRCodeHelper : NSObject

+ (CIImage *)createQRForString:(NSString *)qrString;
+ (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale;

@end
