//
//  MessageCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 02/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIMessageCell.h"
#import "PDMessage.h"
#import "PDTheme.h"
#import "PDUtils.h"

@implementation PDUIMessageCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  //Set up from Theme file
  _logoView.layer.cornerRadius = 25;
  [_logoView setContentMode:UIViewContentModeScaleAspectFill];
  _indicatorView.layer.cornerRadius = 6;
  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (instancetype) initWithFrame:(CGRect)frame message:(PDMessage*)message {
  if (self = [super initWithFrame:frame]) {
    
    float centerlineY = frame.size.height/2;
    _logoView = [[UIImageView alloc] init];
    [_logoView setFrame:CGRectMake(10, centerlineY-25, 50, 50)];
    _logoView.layer.cornerRadius = 25;
    _logoView.clipsToBounds = YES;
    [_logoView setContentMode:UIViewContentModeScaleAspectFill];
    if (message.image) {
      [_logoView setImage:message.image];
    } else {
      [_logoView setImage:PopdeemImage(@"popdeem.images.defaultItemImage")];
    }
    [self addSubview:_logoView];
    
    _bodyLabel = [[UILabel alloc] init];
    float labelWidth = frame.size.width-92;
    NSAttributedString *mainAttributedText = [[NSAttributedString alloc] initWithString:message.body attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    CGRect mainLabelRect = [mainAttributedText boundingRectWithSize:(CGSize){labelWidth, 50}
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                            context:nil];
    
    CGSize mainLabelsize = mainLabelRect.size;
    
    //The max is 40, so pad it out if needed
    float padding = 0;
    if (mainLabelsize.height < 40) {
      padding = (40 - mainLabelsize.height)/2;
    }
    float labelX = 70;
    
    [_bodyLabel setFrame: CGRectMake(labelX, centerlineY-(mainLabelsize.height/2), labelWidth, mainLabelsize.height)];
    if (message.title) {
      [_bodyLabel setText:message.title];
    } else {
      [_bodyLabel setText:message.body];
    }
    [_bodyLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryFontColor")];
    [_bodyLabel setFont:[UIFont systemFontOfSize:14]];
    [_bodyLabel setNumberOfLines:3];
    [self addSubview:_bodyLabel];
    
    if (message.read == NO) {
      _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-22, centerlineY-6, 12, 12)];
      _indicatorView.layer.cornerRadius = 6;
      [self.indicatorView setBackgroundColor:[UIColor colorWithRed:0.169 green:0.522 blue:0.827 alpha:1.000]];
      [self addSubview:_indicatorView];
    } else {
      [self.indicatorView setHidden:YES];
    }

    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-20, 20)];
    [_timeLabel setTextAlignment:NSTextAlignmentRight];
    [_timeLabel setText:[self formattedSentTime:message.createdAt]];
    [_timeLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
    [_timeLabel setFont:[UIFont systemFontOfSize:11]];
    [self addSubview:_timeLabel];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
  }
  return nil;
}

- (void) configureForMessage:(PDMessage*)message {
  if (message.image) {
    [_logoView setImage:message.image];
  } else {
		[_logoView setImage:PopdeemImage(@"popdeem.images.defaultItemImage")];
  }
  [self.bodyLabel setText:message.body];
  [self.timeLabel setText:[self formattedSentTime:message.createdAt]];
  if (message.read == NO) {
    [self.indicatorView setBackgroundColor:[UIColor colorWithRed:0.169 green:0.522 blue:0.827 alpha:1.000]];
  } else {
    [self.indicatorView setHidden:YES];
  }
  [self setBackgroundColor:PopdeemColor(@"popdeem.colors.tableViewCellBackgroundColor")];
  [_bodyLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryFontColor")];
  [_timeLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
