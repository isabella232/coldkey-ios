//
//  CKNewSeedView.m
//  ColdKey
//

#import "CKNewSeedView.h"

#import "CKAppearanceHelper.h"
#import "CKSeedTextView.h"

static const CGFloat kSeedTextViewMarginX = 15;
static const CGFloat kSeedTextViewHeight = 86;

static NSString *NewSeedInfoString()
{
  return
    @"Write down the above seed phrase and store it safely. It can be used to restore your wallet in the future.\n\n"
    @"The next screen will ask you to re-enter the seed.";
}

static NSString *ConfirmSeedInfoString()
{
  return @"Please enter the seed phrase to confirm you have copied it correctly.";
}

static UIColor *GreenBorderColor()
{
  return [UIColor colorWithRed:65.0/255 green:175.0/255 blue:5.0/255 alpha:0.5];
}

@interface CKNewSeedView() <CKSeedTextViewDelegate>

@end

@implementation CKNewSeedView
{
  UILabel *_titleLabel;
  CKSeedTextView *_seedTextView;
  UILabel *_instructionLabel;
  UIButton *_acceptButton;
  UIButton *_confirmButton;
  UIButton *_startOverButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = BackgroundColor();
    
    _titleLabel = TitleLabel();
    [self addSubview:_titleLabel];
    
    _seedTextView = [[CKSeedTextView alloc] initWithFrame:CGRectZero];
    [_seedTextView setIsEditing:NO];
    _seedTextView.delegate = self;
    [self addSubview:_seedTextView];
   
    _instructionLabel = InstructionLabel();
    _instructionLabel.text = NewSeedInfoString();
    [self addSubview:_instructionLabel];
    
    _acceptButton = PrimaryButton();
    [_acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
    [_acceptButton addTarget:self
                        action:@selector(_acceptPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_acceptButton];
    
    _confirmButton = PrimaryButton();
    [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [_confirmButton addTarget:self
                      action:@selector(_confirmPressed:)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmButton];
    
    _startOverButton = LinkButton();
    [_startOverButton setTitle:@"Start Over" forState:UIControlStateNormal];
    [_startOverButton addTarget:self
                      action:@selector(_startOverPressed:)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_startOverButton];
    
    [self setViewState:CKSeedViewStateNew animated:NO];
    [self setConfirmButtonEnabled:NO];
  }
  return self;
}

- (void)dealloc
{
  _seedTextView.delegate = nil;
}

# pragma mark - Layout

- (void)_layoutFrames
{
  CGSize bounds = self.bounds.size;
  
  CGFloat constraintWidth = bounds.width - 2 * XMargin();
  
  CGSize titleLabelSize = [_titleLabel sizeThatFits:CGSizeMake(constraintWidth, MAXFLOAT)];
  _titleLabel.frame = CGRectMake(XMargin(), TitleOriginY(), constraintWidth, titleLabelSize.height);
  
   // TODO: don't hardcode height
  _seedTextView.frame = CGRectMake(kSeedTextViewMarginX, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 10 , bounds.width - 2*kSeedTextViewMarginX, kSeedTextViewHeight);
  
  CGSize instructionLabelSize = [_instructionLabel sizeThatFits:CGSizeMake(constraintWidth, MAXFLOAT)];
  _instructionLabel.frame = CGRectMake(XMargin(), _seedTextView.frame.origin.y + _seedTextView.frame.size.height + 13,
                                       bounds.width - 2*XMargin(), instructionLabelSize.height);
  
  _acceptButton.frame = CGRectMake(XMargin(), bounds.height - ButtonBottomPadding(), constraintWidth, ButtonHeight());
  _confirmButton.frame = CGRectMake(XMargin(), _instructionLabel.frame.origin.y + _instructionLabel.frame.size.height + 13, constraintWidth, ButtonHeight());

  CGFloat startOverButtonY = 0;
  if (!_acceptButton.hidden) {
    startOverButtonY = _acceptButton.frame.origin.y + _acceptButton.frame.size.height + PrimarySecondaryButtonPadding();
  } else {
    startOverButtonY = _confirmButton.frame.origin.y + _confirmButton.frame.size.height + PrimarySecondaryButtonPadding();
  }
  _startOverButton.frame = CGRectMake(XMargin(),startOverButtonY, constraintWidth, ButtonHeight());
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [self _layoutFrames];
}

#pragma mark - Actions

- (void)_startOverPressed:(id)sender
{
  [_delegate newSeedViewDidPressStartOver:self];
}

- (void)_acceptPressed:(id)sender
{
  [_delegate newSeedViewDidPressAccept:self];
}

- (void)_confirmPressed:(id)sender
{
  [_delegate newSeedView:self didPressConfirmWithString:_seedTextView.text];
}

#pragma mark - CKSeedTextViewDelegate

- (void)textViewDidChange:(CKSeedTextView *)textView
{
  [_delegate newSeedView:self didChangeText:textView.text];
}

#pragma mark - Private

- (void)_updateViewState:(CKSeedViewState)state
{
  switch (state) {
    case CKSeedViewStateNew:
      _titleLabel.text = @"Seed Phrase";
      _acceptButton.hidden = NO;
      _confirmButton.hidden = !_acceptButton.hidden;
      _instructionLabel.text = NewSeedInfoString();
      [_seedTextView setIsEditing:NO];
      break;
    case CKSeedViewStateConfirm:
      _titleLabel.text = @"Confirm Seed Phrase";
      _acceptButton.hidden = YES;
      _confirmButton.hidden = !_acceptButton.hidden;
      _instructionLabel.text = ConfirmSeedInfoString();
      [_seedTextView becomeFirstResponder];
      [_seedTextView setIsEditing:YES];
      break;
    default:
      break;
  }
}

#pragma mark - Public

- (void)setMnemonic:(NSString *)mnemonic
{
  _seedTextView.text = mnemonic;
  
  [self setNeedsLayout];
}

- (void)setViewState:(CKSeedViewState)state animated:(BOOL)animated
{
  [self _updateViewState:state];

  void(^animation)(void) = ^{
    [self _layoutFrames];
  };

  if (animated) {
    [UIView animateWithDuration:0.3 animations:animation];
  } else {
    animation();
  }
}

- (void)setConfirmButtonEnabled:(BOOL)enabled
{
  _confirmButton.enabled = enabled;
  _confirmButton.alpha = enabled ? 1.0 : 0.5;
}

- (void)setBorderState:(CKSeedViewBorderState)state
{
  if (state == CKSeedViewBorderStateError) {
    [_seedTextView setBorderColor:[UIColor redColor]];
  } else if (state == CKSeedViewBorderStateMatched) {
    [_seedTextView setBorderColor:GreenBorderColor()];
  } else {
    [_seedTextView setBorderColor:SeedTextViewBorderColor()];
  }
}

@end
