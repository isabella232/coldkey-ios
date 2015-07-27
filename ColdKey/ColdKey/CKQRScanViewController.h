//
//  CKQRScanViewController.h
//  ColdKey
//

#import <AVFoundation/AVFoundation.h>

#import <UIKit/UIKit.h>

@class CKQRScanViewController;

@protocol CKQRScanViewControllerDelegate <NSObject>

@optional

- (void)scanViewController:(CKQRScanViewController *)vc didTapToFocusOnPoint:(CGPoint)aPoint;
- (void)scanViewController:(CKQRScanViewController *)vc didSuccessfullyScan:(NSString *)aScannedValue;

@end

@interface CKQRScanViewController : UIViewController

@property (nonatomic, readwrite, weak) id<CKQRScanViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL touchToFocusEnabled;

- (void)startScanning;
- (void)stopScanning;
- (void)setTorch:(BOOL)torch;

@end
