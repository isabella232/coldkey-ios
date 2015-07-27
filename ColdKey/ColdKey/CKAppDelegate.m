//
//  CKAppDelegate.m
//  ColdKey
//

#import "CKAppDelegate.h"

#import "CKAppearanceHelper.h"
#import "CKRootViewController.h"

@interface CKAppDelegate()

@property (nonatomic, readwrite, strong) UINavigationController *navigationController;
@property (nonatomic, readwrite, strong) CKRootViewController *rootViewController;

@end

@implementation CKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.navigationController = [[UINavigationController alloc] init];
  self.rootViewController = [[CKRootViewController alloc] init];
  [self.navigationController pushViewController:self.rootViewController animated:NO];
  
  [self _setupAppearance];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window setRootViewController:self.navigationController];
  [self.window makeKeyAndVisible];
  
  return YES;
}

#pragma mark - Private

- (void)_setupAppearance
{
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
  
  self.navigationController.navigationBar.translucent = NO;
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

  [[UINavigationBar appearance] setBarTintColor:PrimaryTintColor()];
  [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
  
  [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
}

@end
