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
  self.senderTagLabelString = translationForKey(@"popdeem.message.detail.senderTag", @"Sender:");
  self.senderBodyString = _message.senderName;
  self.dateTagString = translationForKey(@"popdeem.message.detail.dateTag", @"Date:");
  self.dateBodyString = [self formattedSentTime:_message.createdAt];
  self.titleTagString = translationForKey(@"popdeem.message.detail.titleTag", @"Title:");
  self.titleBodyString = _message.title ? _message.title : @"";
  self.bodyTagString = translationForKey(@"popdeem.message.detail.bodyTag", @"Body:");
  self.bodyBodyString = _message.body;
  
  if (_message.imageUrl) {
//    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_message.imageUrl]]];
  } else {
    self.image = PopdeemImage(@"popdeem.images.defaultItemImage");
  }
  if (!_message.read) {
    _message.markAsRead;
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
