//
//  CKRecoveredKeysViewController.m
//  ColdKey
//

#import "CKKeyViewController.h"

#import "CKAppearanceHelper.h"
#import "CKKeyInfo.h"
#import "CKQRCodeHelper.h"
#import "CKKeyView.h"

@implementation CKKeyViewController
{
  CKKeyView *_keyView;
  NSString *_aTitle;
  NSString *_aKey;
}

- (instancetype)initWithTitle:(NSString *)title key:(NSString *)key
{
  if ((self = [super init])) {
    _aTitle = title;
    _aKey = key;
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
  self.navigationItem.titleView = TitleImageView();
  
  _keyView = [[CKKeyView alloc] init];

  self.view = _keyView;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_didTakeScreenshot)
                                               name:UIApplicationUserDidTakeScreenshotNotification
                                             object:nil];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    CIImage *ciImage = [CKQRCodeHelper createQRForString:_aKey];
    UIImage *image = [CKQRCodeHelper createNonInterpolatedUIImageFromCIImage:ciImage withScale:2*[[UIScreen mainScreen] scale]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [_keyView setQRImage:image key:_aKey title:_aTitle];
    });
  });
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - Private

- (void)_didTakeScreenshot
{
  if (_isPrivate) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Taking a screenshot compromises the security "
                                                                @"of this key since other apps may access photos "
                                                                @"on your device."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    [alertView show];
  }
}

@end
