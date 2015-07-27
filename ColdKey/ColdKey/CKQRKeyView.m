//
//  CKQRKeyView.m
//  ColdKey
//

#import "CKQRKeyView.h"

#import "CKAppearanceHelper.h"

static const CGFloat kVerticalPadding = 10;

@implementation CKQRKeyView
{
  UILabel *_titleLabel;
  UIImageView *_qrImageView;
  UITextView *_keyLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _titleLabel = TitleLabel();
    [self addSubview:_titleLabel];
    
    _qrImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_qrImageView];
    
    // Using UITextView so user can copy/paste
    // TODO: Do we want to allow copy/paste of private key?
    _keyLabel = KeyLabel();
    [self addSubview:_keyLabel];
  }
  return self;
}

#pragma mark - Layout

- (CGSize)sizeThatFits:(CGSize)size
{
  CGSize bounds = self.bounds.size;
  
  CGFloat constraintWidth = bounds.width - 2 * XMargin();
  CGSize constraintSize = CGSizeMake(constraintWidth, MAXFLOAT);

  CGFloat height = 0;
  CGSize titleLabelSize = [_titleLabel sizeThatFits:constraintSize];
  CGSize keyLabelSize = [_keyLabel sizeThatFits:constraintSize];
  height += titleLabelSize.height + kVerticalPadding;
  height += QRCodeSize() + kVerticalPadding;
  height += keyLabelSize.height;
  
  return CGSizeMake(size.width, height);
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGSize bounds = self.bounds.size;
  
  CGFloat constraintWidth = bounds.width - 2 * XMargin();
  CGSize constraintSize = CGSizeMake(constraintWidth, MAXFLOAT);
  
  CGSize titleLabelSize = [_titleLabel sizeThatFits:constraintSize];
  _titleLabel.frame = CGRectMake(XMargin(), 0, constraintWidth, titleLabelSize.height);
  
  _qrImageView.frame = CGRectMake(roundf((bounds.width - QRCodeSize())/2),
                                  _titleLabel.frame.origin.y + _titleLabel.frame.size.height + kVerticalPadding,
                                  QRCodeSize(), QRCodeSize());
  
  CGSize qrLabelSize = [_keyLabel sizeThatFits:constraintSize];
  _keyLabel.frame = CGRectMake(XMargin(), _qrImageView.frame.origin.y + _qrImageView.frame.size.height + kVerticalPadding,
                              constraintWidth, qrLabelSize.height);
}

#pragma mark - Public

- (void)setQRImage:(UIImage *)qrImage key:(NSString *)key title:(NSString *)title
{
  _titleLabel.text = title;
  _qrImageView.image = qrImage;
  _keyLabel.text = key;
  
  [self setNeedsLayout];
}

@end
