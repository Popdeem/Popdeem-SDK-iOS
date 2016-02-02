//
//  MessageCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 02/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "MessageCell.h"
#import "PDMessage.h"

@implementation MessageCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  //Set up from Theme file
  _logoView.layer.cornerRadius = 25;
  [_logoView setContentMode:UIViewContentModeScaleAspectFill];
  _indicatorView.layer.cornerRadius = 6;
  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (instancetype) initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _logoView.layer.cornerRadius = 25;
    [_logoView setContentMode:UIViewContentModeScaleAspectFill];
    _indicatorView.layer.cornerRadius = 6;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
  }
  return nil;
}

- (void) configureForMessage:(PDMessage*)message {
  if (message.image) {
    [_logoView setImage:message.image];
  } else {
    [_logoImageView setImage:[UIImage imageNamed:@"starG"]];
  }
  [self.bodyLabel setText:message.body];
  [self.timeLabel setText:[self formattedSentTime:message.createdAt]];
  if (message.read == NO) {
    [self.indicatorView setBackgroundColor:[UIColor colorWithRed:0.169 green:0.522 blue:0.827 alpha:1.000]];
  } else {
    [self.indicatorView setHidden:YES];
  }
  [self setBackgroundColor:PopdeemColor(@"popdeem.messageCenter.tableView.messageCell.backgroundColor")];
  [_bodyLabel setTextColor:PopdeemColor(@"popdeem.messageCenter.tableView.messageCell.bodyTextColor")];
  [_timeLabel setTextColor:PopdeemColor(@"popdeem.messageCenter.tableView.messageCell.timeTextColor")];
}

- (NSString*) formattedSentTime:(NSInteger)absTime {
  NSTimeInterval seconds = [absTime doubleValue];
  
  // (Step 1) Create NSDate object
  NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
  NSLog (@"Epoch time %@ equates to UTC %@", epochTime, epochNSDate);
  
  // (Step 2) Use NSDateFormatter to display epochNSDate in local time zone
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"ccc d MMM HH:mm"];
  NSLog (@"Epoch time %@ equates to %@", epochTime, [dateFormatter stringFromDate:epochNSDate]);
  return [dateFormatter stringFromDate:epochNSDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
