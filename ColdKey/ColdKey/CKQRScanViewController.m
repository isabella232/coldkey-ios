//
//  CKQRScanViewController.m
//  ColdKey
//

#import "CKQRScanViewController.h"

#import "CKAppearanceHelper.h"

@interface CKQRScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureDeviceInput* input;
@property (strong, nonatomic) AVCaptureMetadataOutput* output;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* preview;

@end

@implementation CKQRScanViewController

- (void)viewWillAppear:(BOOL)animated;
{
  [super viewWillAppear:animated];
 
  if (![self _isCameraAvailable]) {
    [self _setupNoCameraView];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  if ([self _isCameraAvailable]) {
    [self _setupScanner];
    [self startScanning];
  }
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  [self stopScanning];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)evt
{
  if (self.touchToFocusEnabled) {
    UITouch *touch=[touches anyObject];
    CGPoint pt= [touch locationInView:self.view];
    [self focus:pt];
  }
}

#pragma mark - NoCamAvailable

- (void)_setupNoCameraView;
{
  UILabel *labelNoCam = [[UILabel alloc] init];
  labelNoCam.text = @"No Camera available";
  labelNoCam.textColor = [UIColor blackColor];
  [self.view addSubview:labelNoCam];
  [labelNoCam sizeToFit];
  labelNoCam.center = self.view.center;
}

#pragma mark - AVFoundationSetup

- (void)_setupScanner
{
  self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  
  self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
  
  self.session = [[AVCaptureSession alloc] init];
  
  self.output = [[AVCaptureMetadataOutput alloc] init];
  [self.session addOutput:self.output];
  [self.session addInput:self.input];
  
  [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
  self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
  
  self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
  self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
  self.preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  
  AVCaptureConnection *con = self.preview.connection;
  
  con.videoOrientation = AVCaptureVideoOrientationPortrait;
  
  [self.view.layer insertSublayer:self.preview atIndex:0];
}

#pragma mark - Helper Methods

- (BOOL)_isCameraAvailable;
{
  NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
  return [videoDevices count] > 0;
}

#pragma mark - Public

- (void)startScanning;
{
  [self.session startRunning];
}

- (void)stopScanning;
{
  [self.session stopRunning];
}

- (void)setTorch:(BOOL)torch
{
  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  [device lockForConfiguration:nil];
  if ( [device hasTorch] ) {
    if (torch) {
      [device setTorchMode:AVCaptureTorchModeOn];
    } else {
      [device setTorchMode:AVCaptureTorchModeOff];
    }
  }
  [device unlockForConfiguration];
}

- (void)focus:(CGPoint)aPoint
{
  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  if([device isFocusPointOfInterestSupported] &&
     [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    double screenWidth = screenRect.size.width;
    double screenHeight = screenRect.size.height;
    double focus_x = aPoint.x/screenWidth;
    double focus_y = aPoint.y/screenHeight;
    if([device lockForConfiguration:nil]) {
      if([self.delegate respondsToSelector:@selector(scanViewController:didTapToFocusOnPoint:)]) {
        [self.delegate scanViewController:self didTapToFocusOnPoint:aPoint];
      }
      [device setFocusPointOfInterest:CGPointMake(focus_x,focus_y)];
      [device setFocusMode:AVCaptureFocusModeAutoFocus];
      if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
        [device setExposureMode:AVCaptureExposureModeAutoExpose];
      }
      [device unlockForConfiguration];
    }
  }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
  for(AVMetadataObject *current in metadataObjects) {
    if([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
      if([self.delegate respondsToSelector:@selector(scanViewController:didSuccessfullyScan:)]) {
        NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
        [self.delegate scanViewController:self didSuccessfullyScan:scannedValue];
      }
    }
  }
}

@end
