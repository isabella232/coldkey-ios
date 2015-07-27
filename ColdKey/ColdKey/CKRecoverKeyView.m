//
//  CKRecoverSeedView.m
//  ColdKey
//

#import "CKRecoverKeyView.h"

#import "CKAppearanceHelper.h"
#import "CKSeedTextView.h"

static const CGFloat kSeedTextViewMarginX = 15;
static const CGFloat kSeedTextViewHeight = 86;

static NSString *RestoreKeyInfoString()
{
  return
  @"Enter the seed phrase that is associated with your public and private keys and we will restore it for you.";
}

@implementation CKRecoverKeyView
{
  UILabel *_titleLabel;
  CKSeedTextView *_seedTextView;
  UILabel *_instructionLabel;
  UIButton *_recoverButton;
}
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = BackgroundColor();
  
    _titleLabel = TitleLabel();
    _titleLabel.text = @"Enter Seed Phrase";
    [self addSubview:_titleLabel];
  
    _seedTextView = [[CKSeedTextView alloc] initWithFrame:CGRectZero];
    [_seedTextView setIsEditing:YES];
    [self addSubview:_seedTextView];

    _instructionLabel = InstructionLabel();
    _instructionLabel.text = RestoreKeyInfoString();
    [self addSubview:_instructionLabel];
    
    _recoverButton = PrimaryButton();
    [_recoverButton setTitle:@"Restore" forState:UIControlStateNormal];
    [_recoverButton addTarget:self
                       action:@selector(_recoverPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_recoverButton];
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
  
  _seedTextView.frame = CGRectMake(kSeedTextViewMarginX, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 10 , bounds.width - 2*kSeedTextViewMarginX, kSeedTextViewHeight);
  
  CGSize instructionLabelSize = [_instructionLabel sizeThatFits:CGSizeMake(constraintWidth, MAXFLOAT)];
  _instructionLabel.frame = CGRectMake(XMargin(), _seedTextView.frame.origin.y + _seedTextView.frame.size.height + 15,
                                       bounds.width - 2*XMargin(), instructionLabelSize.height);
  
  _recoverButton.frame = CGRectMake(XMargin(), _instructionLabel.frame.origin.y + _instructionLabel.frame.size.height + 15, constraintWidth, ButtonHeight());
}

#pragma mark - Actions

- (void)_recoverPressed:(id)sender
{
  [_delegate recoverKeyView:self didPressRecover:_seedTextView.text];
}

#pragma mark - Public

- (void)becomeFirstResponder
{
  [_seedTextView setIsEditing:YES];
  [_seedTextView becomeFirstResponder];
}

@end
