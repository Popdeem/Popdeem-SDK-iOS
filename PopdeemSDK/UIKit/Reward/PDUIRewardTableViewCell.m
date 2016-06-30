//
//  RewardTableViewCell.m
//  Popdeem
//
//  Created by Niall Quinn on 08/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDUIRewardTableViewCell.h"
#import "PDUser.h"
#import "PDTheme.h"

@implementation PDUIRewardTableViewCell

- (id) initWithFrame:(CGRect)frame reward:(PDReward*)reward {
  if (self = [super initWithFrame:frame]){
    
    self.frame = frame;
    BOOL rules = reward.rewardRules.length > 0;
    
    self.reward = reward;
    self.separatorInset = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    float imageSize = 60;
    float indent = (self.frame.size.height - imageSize)/2;
    float leftIndent = indent *0.75;
    
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftIndent, indent, imageSize, imageSize)];
    if (reward.coverImage) {
      [_logoImageView setImage:reward.coverImage];
    } else {
      [_logoImageView setImage:PopdeemImage(@"popdeem.images.defaultItemImage")];
    }
    [_logoImageView setContentMode:UIViewContentModeScaleAspectFit];
    _logoImageView.backgroundColor = [UIColor clearColor];
    _logoImageView.clipsToBounds = YES;
    [self addSubview:_logoImageView];
    
    float centerLineY = frame.size.height/2;
    float labelX = imageSize + 2*leftIndent;
    float labelWidth = frame.size.width - labelX - indent;
    
    
    _mainLabel = [[UILabel alloc] init];
    
    NSAttributedString *mainAttributedText = [[NSAttributedString alloc] initWithString:_reward.rewardDescription attributes:@{NSFontAttributeName: PopdeemFont(@"popdeem.fonts.boldFont", 14)}];
    CGRect mainLabelRect = [mainAttributedText boundingRectWithSize:(CGSize){labelWidth, 40}
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                            context:nil];
    
    CGSize mainLabelsize = mainLabelRect.size;
    
    //The max is 40, so pad it out if needed
    float padding = 0;
    float currentY = 0;
    
    [_mainLabel setFrame: CGRectMake(labelX, currentY, labelWidth, mainLabelsize.height)];
    [_mainLabel setText:reward.rewardDescription];
    [_mainLabel setFont:PopdeemFont(@"popdeem.fonts.boldFont", 14)];
    [_mainLabel setTextColor:[UIColor blackColor]];
    [_mainLabel setTextAlignment:NSTextAlignmentLeft];
    [_mainLabel setNumberOfLines:0];
    [_mainLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    [_mainLabel sizeToFit];
    [self addSubview:_mainLabel];
    currentY += mainLabelsize.height + 3;
    CGSize rulesLabelsize;
    if (rules) {
      _rulesLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, currentY, labelWidth, 30)];
      NSAttributedString *rulesAttributedText = [[NSAttributedString alloc] initWithString:_reward.rewardRules attributes:@{NSFontAttributeName: PopdeemFont(@"popdeem.fonts.primaryFont", 12)}];
      CGRect rulesLabelRect = [rulesAttributedText boundingRectWithSize:(CGSize){labelWidth, 30}
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                                context:nil];
      
      rulesLabelsize = rulesLabelRect.size;
      padding = 0;
      float rulesPadding = 0;
      [_rulesLabel sizeToFit];
      [_rulesLabel setFrame:CGRectMake(labelX, currentY, labelWidth, rulesLabelsize.height)];
      [_rulesLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 12)];
      [_rulesLabel setTextColor:[UIColor blackColor]];
      [_rulesLabel setText:reward.rewardRules];
      [_rulesLabel setNumberOfLines:0];
      currentY += _rulesLabel.frame.size.height+3;
      [self addSubview:_rulesLabel];
      
//      [_mainLabel setFrame:CGRectMake(labelX, _rulesLabel.frame.origin.y-mainLabelsize.height, labelWidth, mainLabelsize.height)];
    }
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, currentY, labelWidth, 15)];
    
    NSString *action;
    
    NSArray *types = _reward.socialMediaTypes;
    if (types.count > 0) {
      if (types.count > 1) {
        //Both Networks
        switch (reward.action) {
          case PDRewardActionCheckin:
            action = @"Check-in or Tweet Required";
            break;
          case PDRewardActionPhoto:
            action = @"Photo Required";
            break;
          case PDRewardActionNone:
            action = @"No Action Required";
          default:
            action = @"No Action Required";
            break;
        }
      } else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeFacebook)]) {
        //Facebook Only
        switch (reward.action) {
          case PDRewardActionCheckin:
            action = @"Check-in Required";
            break;
          case PDRewardActionPhoto:
            action = @"Photo Required";
            break;
          case PDRewardActionNone:
            action = @"No Action Required";
          default:
            action = @"No Action Required";
            break;
        }
      } else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeTwitter)]) {
        //Twitter Only
        switch (reward.action) {
          case PDRewardActionCheckin:
            action = @"Tweet Required";
            break;
          case PDRewardActionPhoto:
            action = @"Tweet with Photo Required";
            break;
          case PDRewardActionNone:
            action = @"No Action Required";
          default:
            action = @"No Action Required";
            break;
        }
			} else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeInstagram)]) {
				//Twitter Only
				action = @"Instagram Photo Required";
				
			}
		} else if (types.count == 0) {
      switch (reward.action) {
        case PDRewardActionCheckin:
          action = @"Check-in Required";
          break;
        case PDRewardActionPhoto:
          action = @"Photo Required";
          break;
        case PDRewardActionNone:
          action = @"No Action Required";
        default:
          action = @"No Action Required";
          break;
      }
    }
    NSString *exp = nil;
    if (reward.unlimitedAvailability == NO) {
      NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
      NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                          fromDate:[NSDate date]
                                                            toDate:[NSDate dateWithTimeIntervalSince1970:_reward.availableUntil]
                                                           options:0];
      
      NSDateComponents *untilComponents = [gregorianCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSince1970:_reward.availableUntil]];
      
      NSInteger days = [components day];
      
      NSTimeInterval interval = [[NSDate dateWithTimeIntervalSince1970:_reward.availableUntil] timeIntervalSinceDate:[NSDate date]];
      int intervalHours = interval/60/60;
      int intervalDays = interval/60/60/24;
      
      if (days>6) {
        exp = [NSString stringWithFormat:@"Exp %ld %@",(long)untilComponents.day, [self monthforIndex:untilComponents.month]];
      } else if (intervalDays < 7 && intervalHours > 23) {
        exp = [NSString stringWithFormat:@"Exp %ld days",(long)intervalDays];
      } else {
        exp = [NSString stringWithFormat:@"Exp %ld hours",(long)intervalHours];
      }
    }
    
    if (reward.unlimitedAvailability) {
      [_infoLabel setText:[NSString stringWithFormat:@"%@",action]];
    } else {
      [_infoLabel setText:[NSString stringWithFormat:@"%@ | %@",action,exp]];
    }
    
    [_infoLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 12)];
    [_infoLabel setTextAlignment:NSTextAlignmentLeft];
    [_infoLabel sizeToFit];
    [self addSubview:_infoLabel];
    
    //Apply Theme
    [self setBackgroundColor:[UIColor clearColor]];
    if (PopdeemThemeHasValueForKey(@"popdeem.colors.tableViewCellBackgroundColor")) {
      [self setBackgroundColor:PopdeemColor(@"popdeem.colors.tableViewCellBackgroundColor")];
      self.contentView.backgroundColor = PopdeemColor(@"popdeem.colors.tableViewCellBackgroundColor");
    }
    [_mainLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryFontColor")];
    [_rulesLabel setTextColor:PopdeemColor(@"popdeem.colors.secondaryFontColor")];
    [_infoLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
  
    
    //Layout
    float labelsHeight = _mainLabel.frame.size.height ;
    if (rules) {
      labelsHeight += _rulesLabel.frame.size.height;
    }
    labelsHeight += _infoLabel.frame.size.height;
    labelsHeight += 10;
    
    float topPadding = (self.frame.size.height - labelsHeight)/2;
    currentY = topPadding;
    [_mainLabel setFrame:CGRectMake(_mainLabel.frame.origin.x, currentY, _mainLabel.frame.size.width, _mainLabel.frame.size.height)];
    currentY += _mainLabel.frame.size.height + 5;
    if (rules) {
      [_rulesLabel setFrame:CGRectMake(_rulesLabel.frame.origin.x, currentY, _rulesLabel.frame.size.width, _rulesLabel.frame.size.height)];
      currentY += _rulesLabel.frame.size.height + 5;
    }
    [_infoLabel setFrame:CGRectMake(_infoLabel.frame.origin.x, currentY, _infoLabel.frame.size.width, _infoLabel.frame.size.height)];
    return self;
  }
  return nil;
}

- (UIEdgeInsets)layoutMargins {
  return UIEdgeInsetsZero;
}

- (NSString*)monthforIndex:(NSInteger)index {
  switch (index) {
    case 1:
      return @"Jan";
      break;
    case 2:
      return @"Feb";
      break;
    case 3:
      return @"Mar";
      break;
    case 4:
      return @"Apr";
      break;
    case 5:
      return @"May";
      break;
    case 6:
      return @"Jun";
      break;
    case 7:
      return @"Jul";
      break;
    case 8:
      return @"Aug";
      break;
    case 9:
      return @"Sep";
      break;
    case 10:
      return @"Oct";
      break;
    case 11:
      return @"Nov";
      break;
    case 12:
      return @"Dec";
      break;
    default:
      break;
  }
  return nil;
}

@end
