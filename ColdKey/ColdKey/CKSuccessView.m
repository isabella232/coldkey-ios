//
//  CKSuccessView.m
//  ColdKey
//

#import "CKSuccessView.h"

#import "CKAppearanceHelper.h"

static NSString *SuccessText()
{
  return @"You've successfully created a set of public and private keys.";
}

@implementation CKSuccessView
{
  UILabel *_titleLabel;
  UILabel *_successLabel;
  UIButton *_showPublicKeyButton;
  UIButton *_showPrivateKeyButton;
  UIButton *_linkKeyButton;
  UIButton *_startOverButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = BackgroundColor();
    
    _titleLabel = TitleLabel();
    _titleLabel.text = @"Success";
    [self addSubview:_titleLabel];
    
    _successLabel = InstructionLabel();
    _successLabel.text = SuccessText();
    [self addSubview:_successLabel];

    _showPublicKeyButton = LinkButton();
    [_showPublicKeyButton setTitle:@"Show Public Key" forState:UIControlStateNormal];
    [_showPublicKeyButton addTarget:self
                      action:@selector(_showPublicKeyPressed:)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_showPublicKeyButton];
    
    _showPrivateKeyButton = LinkButton();
    [_showPrivateKeyButton setTitle:@"Show Private Key" forState:UIControlStateNormal];
    [_showPrivateKeyButton addTarget:self
                             action:@selector(_showPrivateKeyPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_showPrivateKeyButton];
    
    _linkKeyButton = PrimaryButton();
    [_linkKeyButton setTitle:@"Pair Key with Wallet" forState:UIControlStateNormal];
    [_linkKeyButton addTarget:self
                             action:@selector(_linkPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_linkKeyButton];
    
    _startOverButton = LinkButton();
    [_startOverButton setTitle:@"Start Over" forState:UIControlStateNormal];
    [_startOverButton addTarget:self
                         action:@selector(_startOverPressed:)
               forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_startOverButton];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  CGSize bounds = self.bounds.size;
  
  CGFloat constraintWidth = bounds.width - 2 * XMargin();
  
  CGSize titleLabelSize = [_titleLabel sizeThatFits:CGSizeMake(constraintWidth, MAXFLOAT)];
  _titleLabel.frame = CGRectMake(XMargin(), TitleOriginY(), constraintWidth, titleLabelSize.height);

  CGSize successLabelSize = [_successLabel sizeThatFits:CGSizeMake(constraintWidth, MAXFLOAT)];
  _successLabel.frame = CGRectMake(XMargin(), _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 10, constraintWidth, successLabelSize.height);
  
  CGFloat keyButtonsWidth = (constraintWidth - 10)/2;
  CGFloat keyButtonsY = _successLabel.frame.origin.y + _successLabel.frame.size.height;
  _showPublicKeyButton.frame = CGRectMake(XMargin(), keyButtonsY, keyButtonsWidth, ButtonHeight());
  _showPrivateKeyButton.frame = CGRectMake(XMargin() + keyButtonsWidth + 10, keyButtonsY, keyButtonsWidth, ButtonHeight());

  CGFloat buttonY = bounds.height - ButtonBottomPadding();
  _linkKeyButton.frame = CGRectMake(XMargin(), buttonY, constraintWidth, ButtonHeight());
  
  _startOverButton.frame = CGRectMake(XMargin(), _linkKeyButton.frame.origin.y + _linkKeyButton.frame.size.height + 10, constraintWidth, ButtonHeight());
}


#pragma mark - Actions

- (void)_showPublicKeyPressed:(id)sender
{
  [_delegate successViewDidPressShowPublicKey:self];
}

- (void)_showPrivateKeyPressed:(id)sender
{
  [_delegate successViewDidPressShowPrivateKey:self];
}

- (void)_linkPressed:(id)sender
{
  [_delegate successViewDidPressLinkKey:self];
}

- (void)_startOverPressed:(id)sender
{
  [_delegate successViewDidPressStartOver:self];
}

@end
