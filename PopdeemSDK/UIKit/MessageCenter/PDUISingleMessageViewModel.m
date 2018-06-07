//
//  PDSingleMessageViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 15/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUISingleMessageViewModel.h"
#import "PDUtils.h"
#import "PDTheme.h"

@implementation PDUISingleMessageViewModel

- (instancetype) initWithMessage:(PDMessage*)message {
  if (self = [super init]) {
    self.message = message;
    [self setup];
    return self;
  }
  return nil;
}

- (void) setup {
  self.bodyBodyString = _message.body;
  
  NSMutableAttributedString *topAttribString = [[NSMutableAttributedString alloc] init];
  
  NSString *subString = translationForKey(@"popdeem.message.detail.subject", @"Subject:");
  NSMutableAttributedString *subAttribString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", subString] attributes:@{NSFontAttributeName: PopdeemFont(PDThemeFontBold, 12), NSStrokeColorAttributeName: PopdeemColor(PDThemeColorPrimaryFont)}];
  
  [topAttribString appendAttributedString:subAttribString];
  
  NSString *titleString = _message.title ? _message.title : @"";
  
  NSMutableAttributedString *titleAttribString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", titleString] attributes:@{NSFontAttributeName: PopdeemFont(PDThemeFontPrimary, 13), NSStrokeColorAttributeName: PopdeemColor(PDThemeColorPrimaryFont)}];
  
  [topAttribString appendAttributedString:titleAttribString];
  
  NSMutableAttributedString *dateAttribString = [[NSMutableAttributedString alloc] initWithString:[self formattedSentTime:_message.createdAt] attributes:@{NSFontAttributeName: PopdeemFont(PDThemeFontPrimary, 10), NSStrokeColorAttributeName: PopdeemColor(PDThemeColorSecondaryFont)}];
  
  [topAttribString appendAttributedString:dateAttribString];
  
  _topAttributedString = topAttribString;
  
  if (_message.imageUrl) {
    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_message.imageUrl]]];
  } else {
    self.image = PopdeemImage(@"popdeem.images.defaultItemImage");
  }
  if (!_message.read) {
    [_message markAsRead];
  }
}

- (NSString*) formattedSentTime:(NSInteger)absTime {
  NSTimeInterval seconds = absTime;
  
  // (Step 1) Create NSDate object
  NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
  
  // (Step 2) Use NSDateFormatter to display epochNSDate in local time zone
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"ccc d MMM HH:mm"];
  return [dateFormatter stringFromDate:epochNSDate];
}

@end
