//
//  CKRootViewController.m
//  ColdKey
//

#import "CKRootViewController.h"

#import <CoreBitcoin/CoreBitcoin.h>

#import "CKAppearanceHelper.h"
#import "CKKeyInfo.h"
#import "CKKeyInfoHelper.h"
#import "CKNewSeedViewController.h"
#import "CKRecoverKeyViewController.h"
#import "CKRootView.h"

#import "NYMnemonic.h"

// TODO: Randomize the delay duration
static const CGFloat kGenerateDelayDuration = 1.0;

@interface CKRootViewController ()<CKRootViewDelegate>

@end

@implementation CKRootViewController
{
  CKRootView *_rootView;
}

- (void)dealloc
{
  _rootView.delegate = nil;
}

- (void)loadView
{
  self.navigationItem.titleView = TitleImageView();
  
  // Hides back button title
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                           initWithTitle:@""
                                           style:UIBarButtonItemStylePlain
                                           target:nil
                                           action:nil];

  
  _rootView = [[CKRootView alloc] init];
  _rootView.delegate = self;
  self.view = _rootView;
}

#pragma mark - CKRootViewDelegate

- (void)rootViewDidPressGenerate:(UIView *)rootView
{
  [_rootView showLoading];
  [self performSelector:@selector(_handleGenerate) withObject:nil afterDelay:kGenerateDelayDuration];
}

- (void)rootViewDidPressRecover:(UIView *)rootView
{
  CKRecoverKeyViewController *recoverSeedVC = [[CKRecoverKeyViewController alloc] init];
  [self.navigationController pushViewController:recoverSeedVC animated:YES];
}

- (void)rootViewDidPressHelp:(UIView *)rootView
{
  // TODO
}

#pragma mark - Private

- (void)_handleGenerate
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    CKKeyInfo *keyInfo = [self _generateKeys];
    dispatch_async(dispatch_get_main_queue(), ^{
      CKNewSeedViewController *newSeedVC = [[CKNewSeedViewController alloc] initWithKeyInfo:keyInfo];
      [_rootView hideLoading];
      [self.navigationController pushViewController:newSeedVC animated:YES];
    });
  });
}

- (CKKeyInfo *)_generateKeys
{
  // Generating a mnemonic
  NSString *mnemonic = [NYMnemonic generateMnemonicString:@128 language:@"english"];
  CKKeyInfo *keyInfo = KeyInfofromMnemonic(mnemonic);
  return keyInfo;
}

@end
