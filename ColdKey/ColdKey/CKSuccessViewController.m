//
//  CKSuccessViewController.m
//  ColdKey
//

#import "CKSuccessViewController.h"

#import "CKAppearanceHelper.h"
#import "CKKeyInfo.h"
#import "CKKeyViewController.h"
#import "CKQRScanViewController.h"
#import "CKSuccessView.h"

@interface CKSuccessViewController () <
CKSuccessViewDelegate,
CKQRScanViewControllerDelegate,
UIAlertViewDelegate>

@end

@implementation CKSuccessViewController
{
  CKSuccessView *_successView;
  CKKeyInfo *_keyInfo;
  UIAlertView *_startOverAlertView;
  UIAlertView *_pairSucceededAlertView;
  UIAlertView *_pairFailedAlertView;
}

- (instancetype)initWithCKKeyInfo:(CKKeyInfo *)keyInfo
{
  if ((self = [super init])) {
    _keyInfo = keyInfo;
  }
  return self;
}

- (void)dealloc
{
  _successView.delegate = nil;
  _startOverAlertView.delegate = nil;
  _pairSucceededAlertView.delegate = nil;
  _pairFailedAlertView.delegate = nil;
}

- (void)loadView
{
  self.navigationItem.titleView = TitleImageView();
  self.navigationItem.hidesBackButton = YES;
  
  // Hides back button title
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                           initWithTitle:@""
                                           style:UIBarButtonItemStylePlain
                                           target:nil
                                           action:nil];


  _successView = [[CKSuccessView alloc] init];
  _successView.delegate = self;
  
  self.view = _successView;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (alertView == _startOverAlertView) {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
      [self.navigationController popToRootViewControllerAnimated:YES];
    }
  } else if (alertView == _pairSucceededAlertView) {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
      [self.navigationController popToRootViewControllerAnimated:YES]; // TODO: where to go from here?
    }
  } else if (alertView == _pairFailedAlertView) {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
      [self.navigationController popViewControllerAnimated:YES];
    }
  }
}

#pragma mark - CKSuccessViewDelegate

- (void)successViewDidPressShowPublicKey:(CKSuccessView *)view
{
  CKKeyViewController *keyVC = [[CKKeyViewController alloc] initWithTitle:@"Public Key" key:_keyInfo.publicKey];
  keyVC.isPrivate = NO;
  [self.navigationController pushViewController:keyVC animated:YES];
}

- (void)successViewDidPressShowPrivateKey:(CKSuccessView *)view
{
  CKKeyViewController *keyVC = [[CKKeyViewController alloc] initWithTitle:@"Private Key" key:_keyInfo.privateKey];
  keyVC.isPrivate = YES;
  [self.navigationController pushViewController:keyVC animated:YES];
}

- (void)successViewDidPressLinkKey:(CKSuccessView *)view
{
  CKQRScanViewController *scanVC = [[CKQRScanViewController alloc] init];
  scanVC.delegate = self;
  [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)successViewDidPressStartOver:(CKSuccessView *)view
{
  _startOverAlertView = [[UIAlertView alloc] initWithTitle:@"Start Over"
                                                   message:@"Are you sure you want to discard these keys and start over?"
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Start Over", nil];
  [_startOverAlertView show];
}


#pragma mark - CKQRScanViewControllerDelegate

- (void)scanViewController:(CKQRScanViewController *)vc didSuccessfullyScan:(NSString *)aScannedValue
{
  vc.delegate = nil;

  [vc stopScanning];
  
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  NSLog(@"scanned value %@", aScannedValue);
  
  [self _postRequest:aScannedValue xpub:_keyInfo.publicKey];
}


- (void)_postRequest:(NSString *)secret xpub:(NSString *)xpub
{
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://cerberus.local:3000/api/v1/keychains/coldkey"]];
  [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  request.HTTPMethod = @"POST";
  
  NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                          secret, @"secret",
                          xpub, @"xpub",
                          nil];
  NSError *error;
  NSData *postdata = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
  [request setHTTPBody:postdata];
  
  // Create url connection and fire request
  NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
  
  [conn start];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
  NSLog(@"Did Receive Response %@", response);
  NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
  NSInteger code = [httpResponse statusCode];

  if (code == 200) {
    [self _handleSuccess];
  } else {
    [self _handleError];
  }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSLog(@"body %@", body);
}


- (void)_handleSuccess
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Pairing Succeeded"
                                                      message:@"These keys have been successfully paired with your BitGo wallet"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil];
  [alertView show];
}

- (void)_handleError
{
  // TODO: More advanced error handling. ie. check for specific error codes
  _pairFailedAlertView = [[UIAlertView alloc] initWithTitle:@"Pairing Failed"
                                                      message:@"Something went wrong. Please try again."
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil];
  [_pairFailedAlertView show];
}



@end
