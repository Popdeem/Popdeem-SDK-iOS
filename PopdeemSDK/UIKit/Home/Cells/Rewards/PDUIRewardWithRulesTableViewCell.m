//
//  PDUIRewardWithRulesTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 15/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIRewardWithRulesTableViewCell.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDUser.h"

@implementation PDUIRewardWithRulesTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	self.separatorInset = UIEdgeInsetsZero;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[_rewardImageView setImage:PopdeemImage(@"popdeem.images.defaultItemImage")];
	
	[_label setFont:PopdeemFont(@"popdeem.fonts.boldFont", 14)];
	[_label setTextColor:PopdeemColor(@"popdeem.colors.primaryFontColor")];
	
	
	[self setBackgroundColor:[UIColor clearColor]];
	if (PopdeemThemeHasValueForKey(@"popdeem.colors.tableViewCellBackgroundColor")) {
		[self setBackgroundColor:PopdeemColor(@"popdeem.colors.tableViewCellBackgroundColor")];
		self.contentView.backgroundColor = PopdeemColor(@"popdeem.colors.tableViewCellBackgroundColor");
	}
}

- (void) setupForReward:(PDReward*)reward {
	
	if (reward.coverImage) {
		[self.rewardImageView setImage:reward.coverImage];
	} else {
		[self.rewardImageView setImage:PopdeemImage(@"popdeem.images.defaultItemImage")];
	}
	
	NSString *description = reward.rewardDescription;
	NSString *rules = reward.rewardRules;
	NSString *info = [self infoStringForReward:reward];
	
	NSMutableAttributedString *labelAttString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{}];
	
	NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n",description] attributes:@{NSFontAttributeName : PopdeemFont(@"popdeem.fonts.boldFont", 14), NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryFontColor")}];
	
	[labelAttString appendAttributedString:descriptionString];
	
	if (rules.length > 0) {
		NSMutableAttributedString *rulesString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n",rules] attributes:@{NSFontAttributeName : PopdeemFont(@"popdeem.fonts.primaryFont", 12), NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.secondaryFontColor")}];
		[labelAttString appendAttributedString:rulesString];
	}
	
	NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc] initWithString:info attributes:@{NSFontAttributeName : PopdeemFont(@"popdeem.fonts.primaryFont", 12), NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryAppColor")}];
	
	[labelAttString appendAttributedString:infoString];
	[_label setAttributedText:labelAttString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins {
	return UIEdgeInsetsZero;
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
