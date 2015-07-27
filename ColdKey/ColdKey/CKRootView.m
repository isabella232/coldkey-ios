//
//  CKRootView.m
//  ColdKey
//

#import "CKRootView.h"

#import "CKAppearanceHelper.h"

@implementation CKRootView
{
  UIImageView *_logoView;
  UILabel *_coldKeyLabel;
  UIButton *_generateButton;
  UIButton *_recoverButton;
  UIButton *_helpButton;
  UIActivityIndicatorView *_activityView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = BackgroundColor();
    
    _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bitgo-logo.png"]];
    _logoView.alpha = 0.75;
    [self addSubview:_logoView];
   
    _coldKeyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _coldKeyLabel.text = @"ColdKey";
    _coldKeyLabel.textColor = PrimaryTintColor();
    _coldKeyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
    [self addSubview:_coldKeyLabel];
    
    _generateButton = PrimaryButton();
    [_generateButton setTitle:@"Create New Key" forState:UIControlStateNormal];
    [_generateButton addTarget:self
                        action:@selector(_generatePressed:)
              forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_generateButton];

    _recoverButton = SecondaryButton();
    [_recoverButton setTitle:@"Restore Key" forState:UIControlStateNormal];
    [_recoverButton addTarget:self
                        action:@selector(_recoverPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_recoverButton];
    
    _helpButton = SecondaryButton();
    [_helpButton setTitle:@"Help" forState:UIControlStateNormal];
    [_helpButton addTarget:self
                       action:@selector(_helpPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_helpButton];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.color = PrimaryTintColor();
    [self addSubview:_activityView];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  CGSize bounds = self.bounds.size;
  
  CGFloat constraintWidth = bounds.width - 2 * XMargin();
  
  CGFloat y = bounds.height - ButtonBottomPadding();
  _generateButton.frame = CGRectMake(XMargin(), y, constraintWidth, ButtonHeight());
  
  CGFloat smButtonWidth = roundf(constraintWidth/3);
  CGFloat lgButtonWidth = constraintWidth - smButtonWidth - 10;

  _helpButton.frame = CGRectMake(XMargin(), _generateButton.frame.origin.y + _generateButton.frame.size.height + 10, smButtonWidth, ButtonHeight());
  _recoverButton.frame = CGRectMake(XMargin() + smButtonWidth + 10, _generateButton.frame.origin.y + _generateButton.frame.size.height + 10, lgButtonWidth, ButtonHeight());

  CGSize labelSize = [_coldKeyLabel sizeThatFits:CGSizeMake(constraintWidth, MAXFLOAT)];
  CGFloat logoY = roundf((_generateButton.frame.origin.y - (_logoView.frame.size.height + labelSize.height + 10))/2);

  _logoView.frame = CGRectMake(roundf((bounds.width - _logoView.frame.size.width)/2), logoY, _logoView.frame.size.width, _logoView.frame.size.height);
  _coldKeyLabel.frame = CGRectMake(roundf((bounds.width - labelSize.width)/2), _logoView.frame.origin.y + _logoView.frame.size.height + 10,
                                   constraintWidth, labelSize.height);
  
  _activityView.frame = CGRectMake(roundf((bounds.width - _activityView.frame.size.width)/2),
                                   _coldKeyLabel.frame.origin.y + _coldKeyLabel.frame.size.height + 10,
                                   _activityView.frame.size.width, _activityView.frame.size.height);
}

#pragma mark - Private

- (void)_generatePressed:(id)sender
{
  [_delegate rootViewDidPressGenerate:self];
}

- (void)_recoverPressed:(id)sender
{
  [_delegate rootViewDidPressRecover:self];
}

- (void)_helpPressed:(id)sender
{
  [_delegate rootViewDidPressHelp:self];
}

#pragma mark - Public

- (void)showLoading
{
  _activityView.hidden = NO;
  [_activityView startAnimating];
}

- (void)hideLoading
{
  [_activityView stopAnimating];
  _activityView.hidden = YES;
}

@end
