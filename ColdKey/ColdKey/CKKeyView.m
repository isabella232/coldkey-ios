//
//  CKKeyView.m
//  ColdKey
//

#import "CKKeyView.h"

#import "CKAppearanceHelper.h"
#import "CKQRKeyView.h"

@implementation CKKeyView
{
  CKQRKeyView *_qrKeyView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = BackgroundColor();
    
    _qrKeyView = [[CKQRKeyView alloc] initWithFrame:CGRectZero];
    [self addSubview:_qrKeyView];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  CGSize bounds = self.bounds.size;
  
  CGFloat constraintWidth = bounds.width - 2 * XMargin();
  CGSize constraintSize = CGSizeMake(constraintWidth, MAXFLOAT);
  
  CGSize qrKeyViewSize = [_qrKeyView sizeThatFits:constraintSize];
  _qrKeyView.frame = CGRectMake(0, TitleOriginY(), bounds.width, qrKeyViewSize.height);
}

#pragma mark - Public

- (void)setQRImage:(UIImage *)image key:(NSString *)key title:(NSString *)title
{
  [_qrKeyView setQRImage:image key:key title:title];

  [self setNeedsLayout];
}

@end
