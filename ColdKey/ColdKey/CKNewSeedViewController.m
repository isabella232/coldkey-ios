//
//  CKNewSeedViewController.m
//  ColdKey
//

#import "CKNewSeedViewController.h"

#import "CKAppearanceHelper.h"
#import "CKKeyInfo.h"
#import "CKNewSeedView.h"
#import "CKStringHelper.h"
#import "CKSuccessViewController.h"

@interface CKNewSeedViewController ()<CKNewSeedViewDelegate, UIAlertViewDelegate>

@end

@implementation CKNewSeedViewController
{
  CKKeyInfo *_keyInfo;
  CKNewSeedView *_newSeedView;
  UIAlertView *_acceptAlertView;
  UIAlertView *_startOverAlertView;
  UIAlertView *_incorrectSeedAlertView;
  UIAlertView *_screenshotWarningAlertView;
}

- (instancetype)initWithKeyInfo:(CKKeyInfo *)keyInfo
{
  if ((self = [super init])) {
    _keyInfo = keyInfo;
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
  _newSeedView.delegate = nil;
  _acceptAlertView.delegate = nil;
  _startOverAlertView.delegate = nil;
  _incorrectSeedAlertView.delegate = nil;
  _screenshotWarningAlertView.delegate = nil;
}

- (void)loadView
{
  self.navigationItem.titleView = TitleImageView();
  self.navigationItem.hidesBackButton = YES;
  
  _newSeedView = [[CKNewSeedView alloc] init];
  _newSeedView.delegate = self;
  [_newSeedView setMnemonic:_keyInfo.mnemonic];
  
  self.view = _newSeedView;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_didTakeScreenshot)
                                               name:UIApplicationUserDidTakeScreenshotNotification
                                             object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (alertView == _acceptAlertView) {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
      [_newSeedView setViewState:CKSeedViewStateConfirm animated:YES];
    }
  } else if (alertView == _startOverAlertView) {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
      [self.navigationController popToRootViewControllerAnimated:YES];
    }
  } else if (alertView == _screenshotWarningAlertView) {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
      [self.navigationController popToRootViewControllerAnimated:YES];
    }
  }
}

#pragma mark - CKNewSeedViewDelegate

- (void)newSeedViewDidPressStartOver:(CKNewSeedView *)view
{
  _startOverAlertView = [[UIAlertView alloc] initWithTitle:@"Start Over"
                                                   message:@"Are you sure you want to discard this seed phrase and start over?"
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Start Over", nil];
  [_startOverAlertView show];
}

- (void)newSeedViewDidPressAccept:(CKNewSeedView *)view
{
  _acceptAlertView = [[UIAlertView alloc] initWithTitle:@"Accept"
                                               message:@"Have you copied the seed phrase? The next screen will ask you to re-enter it."
                                              delegate:self
                                     cancelButtonTitle:@"No"
                                     otherButtonTitles:@"Yes", nil];
  [_acceptAlertView show];
}

- (void)newSeedView:(CKNewSeedView *)view didPressConfirmWithString:(NSString *)string
{
  if ([self _seedMatchesString:string]) {
    CKSuccessViewController *vc = [[CKSuccessViewController alloc] initWithCKKeyInfo:_keyInfo];
    [self.navigationController pushViewController:vc animated:YES];
    
  } else {
    _incorrectSeedAlertView = [[UIAlertView alloc] initWithTitle:@"Incorrect Seed"
                                                        message:@"The seed you entered does not match the seed we provided you. "
                                                                @"Please recheck what you've written down and try again"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    [_incorrectSeedAlertView show];
  }
}

- (void)newSeedView:(CKNewSeedView *)view didChangeText:(NSString *)string
{
  if ([self _seedMatchesString:string]) {
    [_newSeedView setConfirmButtonEnabled:YES];
    [_newSeedView setBorderState:CKSeedViewBorderStateMatched];
  } else {
    [_newSeedView setConfirmButtonEnabled:NO];
    if (![self _seedPartiallyMatchesString:string]) {
      [_newSeedView setBorderState:CKSeedViewBorderStateError];
    } else {
      [_newSeedView setBorderState:CKSeedViewBorderStateDefault];
    }
  }
}

#pragma mark - Private

- (BOOL)_seedMatchesString:(NSString *)string
{
  NSString *trimmed = TrimAndSquashText(string);
  return [trimmed isEqualToString:_keyInfo.mnemonic] || [trimmed isEqualToString:@"t t"]; // testing
}

- (BOOL)_seedPartiallyMatchesString:(NSString *)string
{
  NSString *trimmed = TrimAndSquashText(string);
  if (trimmed.length > 0) {
    NSString *prefix = [_keyInfo.mnemonic substringToIndex:trimmed.length];
    return [prefix isEqualToString:trimmed];
  } else {
    return YES;
  }
}

- (void)_didTakeScreenshot
{
  _screenshotWarningAlertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                           message:@"Taking a screenshot compromises the security of "
                                                                   @"this seed phrase since other apps may access photos "
                                                                   @"on your device."
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Start Over", nil];
  [_screenshotWarningAlertView show];
}

@end
