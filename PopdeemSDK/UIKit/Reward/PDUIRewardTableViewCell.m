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
#import "PDUtils.h"

@implementation PDUIRewardTableViewCell

- (id) initWithFrame:(CGRect)frame reward:(PDReward*)reward {
  if (self = [super initWithFrame:frame]){
    
    self.frame = frame;
    
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
    
		
		_primaryAppColor = PopdeemColor(PDThemeColorPrimaryApp);
		_primaryFontColor = PopdeemColor(PDThemeColorPrimaryFont);
		_secondaryFontColor = PopdeemColor(PDThemeColorSecondaryFont);
		
		if (reward.coverImageUrl) {
			if ([reward.coverImageUrl rangeOfString:@"reward_default"].location != NSNotFound) {
				[self.logoImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
			} else if (reward.coverImage) {
				[self.logoImageView setImage:reward.coverImage];
			} else {
				[self.logoImageView setImage:nil];
			}
		} else {
			[self.logoImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
		}
		
		NSString *description = reward.rewardDescription;
		NSString *rulesStr = reward.rewardRules;
		
		NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
		ps.paragraphSpacing = 2.0;
		ps.lineSpacing = 0;
		NSMutableAttributedString *labelAttString = [[NSMutableAttributedString alloc] initWithString:@""
																																											 attributes:@{}];
		
		NSMutableParagraphStyle *innerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
		innerParagraphStyle.lineSpacing = 0;
		
		
		NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc]
																										initWithString:[NSString stringWithFormat:@"%@",description]
																										attributes:@{
																																 NSFontAttributeName : PopdeemFont(PDThemeFontBold, 14),
																																 NSForegroundColorAttributeName : _primaryFontColor
																																 }];
		

		
    float labelX = imageSize + 2*leftIndent;
    float labelWidth = frame.size.width - labelX - indent;
    
    CGRect titleLabelRect = CGRectMake(labelX, 0,labelWidth , 50);
    if (_mainLabel == nil) {
      _mainLabel = [[UILabel alloc] initWithFrame:titleLabelRect];
      [self addSubview:_mainLabel];
    } else {
      [_mainLabel setFrame:titleLabelRect];
    }
    [_mainLabel setNumberOfLines:2];
    [_mainLabel setAttributedText:descriptionString];
    [_mainLabel setContentMode:UIViewContentModeCenter];
    [_mainLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    CGSize size = [_mainLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
    CGRect labelFrame = _mainLabel.frame;
    labelFrame.size.height = size.height;
    _mainLabel.frame = labelFrame;
    _mainLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    float innerSpacing = 3;
    
    float currentY = _mainLabel.frame.size.height + innerSpacing;
    

    if (rulesStr.length > 0) {
      NSMutableAttributedString *rulesString = [[NSMutableAttributedString alloc]
                                                initWithString:[NSString stringWithFormat:@"%@",rulesStr]
                                                attributes:@{
                                                             NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
                                                             NSForegroundColorAttributeName : _secondaryFontColor
                                                             }];
      [labelAttString appendAttributedString:rulesString];
      
      CGRect infoLabelRect = CGRectMake(labelX, _mainLabel.frame.size.height ,labelWidth , 50);
      if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] initWithFrame:infoLabelRect];
        [self addSubview:_infoLabel];
      } else {
        [_infoLabel setFrame:infoLabelRect];
      }
      [_infoLabel setNumberOfLines:3];
      [_infoLabel setAttributedText:rulesString];
      CGSize infoSize = [_infoLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
      CGRect infoLabelFrame = _infoLabel.frame;
      infoLabelFrame.size.height = infoSize.height;
      _infoLabel.frame = infoLabelFrame;
      currentY += _infoLabel.frame.size.height;
      _infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
      currentY += innerSpacing;
    }
    
    float combinedHeight = currentY;
    float padding = 100 - combinedHeight;
    float topPadding = padding/2;
    
    currentY = topPadding;
    [_mainLabel setFrame:CGRectMake(labelX, currentY, _mainLabel.frame.size.width, _mainLabel.frame.size.height)];
    currentY += _mainLabel.frame.size.height + innerSpacing;
    if (rulesStr.length > 0) {
      [_infoLabel setFrame:CGRectMake(labelX, currentY, _infoLabel.frame.size.width, _infoLabel.frame.size.height)];
    }
    
    
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

- (NSString*) infoStringForReward:(PDReward*)reward {
	NSString *action;
	
	NSArray *types = reward.socialMediaTypes;
	if (types.count > 0) {
		if (types.count > 1) {
			//Both Networks
			switch (reward.action) {
				case PDRewardActionCheckin:
					action = @"Check-in or Tweet Required";
					break;
				case PDRewardActionPhoto:
					action = translationForKey(@"popdeem.claim.action.photo", @"Photo Required");
					break;
				case PDRewardActionNone:
					action = @"No Action Required";
          break;
        case PDRewardActionSocialLogin:
          action = @"Connect Account";
          break;
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
					action = translationForKey(@"popdeem.claim.action.photo", @"Photo Required");
					break;
				case PDRewardActionNone:
					action = @"No Action Required";
          break;
        case PDRewardActionSocialLogin:
          action = @"Connect Account";
          break;
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
					action = translationForKey(@"popdeem.claim.action.photo", @"Photo Required");
					break;
				case PDRewardActionNone:
					action = @"No Action Required";
          break;
        case PDRewardActionSocialLogin:
          action = @"Connect Account";
          break;
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
				action = translationForKey(@"popdeem.claim.action.photo", @"Photo Required");
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
																													toDate:[NSDate dateWithTimeIntervalSince1970:reward.availableUntil]
																												 options:0];
		
		NSDateComponents *untilComponents = [gregorianCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSince1970:reward.availableUntil]];
		
		NSInteger days = [components day];
		
		NSTimeInterval interval = [[NSDate dateWithTimeIntervalSince1970:reward.availableUntil] timeIntervalSinceDate:[NSDate date]];
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
		return [NSString stringWithFormat:@"%@",action];
	} else {
		return [NSString stringWithFormat:@"%@ | %@",action,exp];
	}
	
}

@end
