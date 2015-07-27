//
//  CKRecoverSeedViewController.m
//  ColdKey
//

#import "CKRecoverKeyViewController.h"

#import <CoreBitcoin/CoreBitcoin.h>

#import "CKAppearanceHelper.h"
#import "CKKeyInfo.h"
#import "CKKeyInfoHelper.h"
#import "CKKeyViewController.h"
#import "CKRecoverKeyView.h"
#import "CKStringHelper.h"

@interface CKRecoverKeyViewController ()<CKRecoverKeyViewDelegate>

@end

@implementation CKRecoverKeyViewController
{
  CKRecoverKeyView *_recoverSeedView;
}

- (void)dealloc
{
  _recoverSeedView.delegate = nil;
}

- (void)loadView
{
  self.navigationItem.titleView = TitleImageView();
  
  _recoverSeedView = [[CKRecoverKeyView alloc] init];
  _recoverSeedView.delegate = self;
  
  self.view = _recoverSeedView;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [_recoverSeedView becomeFirstResponder];
}

#pragma mark - CKRecoverSeedViewDelegate

- (void)recoverKeyView:(CKRecoverKeyView *)view didPressRecover:(NSString *)seed
{
  NSString *trimmed = TrimAndSquashText(seed);
 
  // Error checking
  NSArray *components = [trimmed componentsSeparatedByString:@" "];
  if (components.count < 12) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Too short"
                                                        message:@"The seed phrase you entered is too short. Please try again."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    return;
  } else if (components.count > 12) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Too long"
                                                        message:@"The seed phrase you entered is too long. Please try again."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    return;
  }
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    CKKeyInfo *keyInfo = KeyInfofromMnemonic(trimmed);
    dispatch_async(dispatch_get_main_queue(), ^{
      CKKeyViewController *vc = [[CKKeyViewController alloc] initWithTitle:@"Private Key" key:keyInfo.privateKey];
      vc.isPrivate = YES;
      [self.navigationController pushViewController:vc animated:YES];
    });
  });
}

@end
