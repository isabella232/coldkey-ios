//
//  CKStringHelper.m
//  ColdKey
//

#import "CKStringHelper.h"

NSString *TrimAndSquashText(NSString *text)
{
  // Trim and ignore extra spaces.
  NSString *squashed = [text stringByReplacingOccurrencesOfString:@"[ ]+"
                                                         withString:@" "
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange(0, text.length)];
  NSString *trimmed = [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  return trimmed;
}