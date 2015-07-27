//
//  CKSeedTextView.m
//  ColdKey
//

#import "CKSeedTextView.h"

#import "CKAppearanceHelper.h"

UIColor *SeedTextViewBorderColor()
{
  return [UIColor colorWithRed:189.0/255 green:188.0/255 blue:188.0/255 alpha:0.5];
}

@interface CKSeedTextView() <UITextViewDelegate>

@end

@implementation CKSeedTextView
{
  UIView *_backgroundView;
  UITextView *_mnemonicTextView;
  UILabel *_mnemonicLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    _backgroundView.layer.cornerRadius = 3.0;
    _backgroundView.layer.borderWidth = 1.0;
    _backgroundView.layer.borderColor = SeedTextViewBorderColor().CGColor;
    [self addSubview:_backgroundView];
    
    _mnemonicTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    _mnemonicTextView.backgroundColor = [UIColor clearColor];
    _mnemonicTextView.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    _mnemonicTextView.textColor = GrayTextColor();
    _mnemonicTextView.spellCheckingType = UITextSpellCheckingTypeNo;
    _mnemonicTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _mnemonicTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _mnemonicTextView.delegate = self;
    [self addSubview:_mnemonicTextView];
    
    _mnemonicLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _mnemonicLabel.font = _mnemonicTextView.font;
    _mnemonicLabel.textColor = _mnemonicTextView.textColor;
    _mnemonicLabel.numberOfLines = 0;
    [self addSubview:_mnemonicLabel];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  CGSize bounds = self.bounds.size;

  // TODO: make this flexible
  _backgroundView.frame = CGRectMake(0, 0 , bounds.width, bounds.height);
  _mnemonicLabel.frame = CGRectMake(10, _backgroundView.frame.origin.y, bounds.width - 2 * 10, _backgroundView.frame.size.height);
  _mnemonicTextView.frame = _mnemonicLabel.frame;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
  [_delegate textViewDidChange:self];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  // Disables double space shortcut
  return ![text isEqualToString:@". "];
}

#pragma mark - Public

- (void)setText:(NSString *)text
{
  _mnemonicLabel.text = text;
}

- (NSString *)text {
  return _mnemonicTextView.text;
}

- (void)setIsEditing:(BOOL)editing
{
  _mnemonicTextView.hidden = !editing;
  _mnemonicLabel.hidden = !_mnemonicTextView.hidden;
}

- (void)becomeFirstResponder
{
  [_mnemonicTextView becomeFirstResponder];
}

- (void)setBorderColor:(UIColor *)color
{
  _backgroundView.layer.borderColor = color.CGColor;
}

@end
