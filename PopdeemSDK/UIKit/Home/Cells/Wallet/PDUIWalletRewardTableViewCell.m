//
//  PDUIWalletRewardTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIWalletRewardTableViewCell.h"
#import "PDTheme.h"
#import "PDUtils.h"

@interface PDUIWalletRewardTableViewCell()
@property (nonatomic, retain) UIColor *primaryAppColor;
@property (nonatomic, retain) UIColor *primaryFontColor;
@property (nonatomic, retain) UIColor *secondaryFontColor;
@end

@implementation PDUIWalletRewardTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	self.separatorInset = UIEdgeInsetsZero;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[_rewardImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
	[_mainLabel setFont:PopdeemFont(PDThemeFontBold, 14)];
	[_mainLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
	[self setBackgroundColor:[UIColor clearColor]];
	if (PopdeemThemeHasValueForKey(PDThemeColorTableViewCellBackground)) {
		[self setBackgroundColor:PopdeemColor(PDThemeColorTableViewCellBackground)];
		self.contentView.backgroundColor = PopdeemColor(PDThemeColorTableViewCellBackground);
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

- (void) setupForReward:(PDReward *)reward theme:(PDBrandTheme*)theme {
	_brandTheme = theme;
	[self setupForReward:reward];
}

- (void) setupForReward:(PDReward*)reward {
	if (_brandTheme) {
		_primaryAppColor = PopdeemColorFromHex(_brandTheme.primaryAppColor);
		_primaryFontColor = PopdeemColorFromHex(_brandTheme.primaryTextColor);
		_secondaryFontColor = PopdeemColorFromHex(_brandTheme.secondaryTextColor);
	} else {
		_primaryAppColor = PopdeemColor(PDThemeColorPrimaryApp);
		_primaryFontColor = PopdeemColor(PDThemeColorPrimaryFont);
		_secondaryFontColor = PopdeemColor(PDThemeColorSecondaryFont);
	}
	
	[_mainLabel setTextColor:_primaryFontColor];
	
	self.clipsToBounds = YES;
	if (reward.coverImageUrl) {
		if ([reward.coverImageUrl rangeOfString:@"reward_default"].location != NSNotFound) {
			[self.rewardImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
		} else if (reward.coverImage) {
			[self.rewardImageView setImage:reward.coverImage];
		} else {
			[self.rewardImageView setImage:nil];
		}
	} else {
		[self.rewardImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
	}
	
	NSString *labelLineTwo;
	NSDate *creditDate;
	NSDateFormatter *formatter;
	NSString *stringDate;
	switch (reward.type) {
		case PDRewardTypeSweepstake:
			labelLineTwo = translationForKey(@"popdeem.wallet.sweepstake.redeemText", @"You have been entered in this competition.");
			break;
		case PDRewardTypeCredit:
			creditDate = [NSDate dateWithTimeIntervalSince1970:reward.claimedAt];
			formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:@"d MMM y"];
			stringDate = [formatter stringFromDate:creditDate];
			labelLineTwo = [NSString stringWithFormat:@"%@ granted on %@",reward.creditString, stringDate];
			break;
		case PDRewardTypeCoupon:
		case PDRewardTypeInstant:
			labelLineTwo = translationForKey(@"popdeem.wallet.coupon.redeemText", @"Redeem at the point of sale.");
			break;
	}
	
	NSMutableAttributedString *labelAttString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{}];
	
	NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc]
			initWithString:[NSString stringWithFormat:@"%@ \n",reward.rewardDescription]
				attributes:@{
						NSFontAttributeName : PopdeemFont(PDThemeFontBold, 14),
						NSForegroundColorAttributeName : _primaryFontColor
				}];
	
	[labelAttString appendAttributedString:descriptionString];

	NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc]
			initWithString:labelLineTwo
				attributes:@{
						NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
						NSForegroundColorAttributeName : _primaryAppColor
				}];
	
	[labelAttString appendAttributedString:infoString];
	NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
	ps.lineSpacing = 2.0;
	[labelAttString addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, labelAttString.length)];
	[_mainLabel setAttributedText:labelAttString];
	
//	float centerY = self.frame.size.height/2;
	
	if (reward.type == PDRewardTypeCoupon) {
		[_instructionsLabel setHidden:YES];
		return;
	}
	
	
	NSMutableAttributedString *instructionsAttString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{}];
	NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc]
																									initWithString:@"Sweepstake Entry\n\n"
																									attributes:@{
																															 NSFontAttributeName : PopdeemFont(PDThemeFontBold, 14),
																															 NSForegroundColorAttributeName : _primaryFontColor
																															 }];
	[instructionsAttString appendAttributedString:titleString];
	
	NSString *instStr;
	if ([[self drawString:reward] length] > 1) {
			instStr = [NSString stringWithFormat:@"- You are now in the draw.\n- You will be notified if you are the winner.\n- %@",[self drawString:reward]];
	} else {
		instStr = @"- You are now in the draw.\n- You will be notified if you are the winner.";
	}
	
	NSMutableAttributedString *instructionsInfoString = [[NSMutableAttributedString alloc]
																					 initWithString:instStr
																					 attributes:@{
																												NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
																												NSForegroundColorAttributeName : _primaryFontColor
																												}];
	[instructionsAttString appendAttributedString:instructionsInfoString];
	
	[self.instructionsLabel setNumberOfLines:0];
	[self.instructionsLabel setAttributedText:instructionsAttString];
	[self.instructionsLabel setHidden:NO];
	
}

- (NSString*) drawString:(PDReward*)reward {
	NSString *expiresString;
	if (reward.availableUntil) {
//		NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//		NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
//																												fromDate:[NSDate date]
//																													toDate:[NSDate dateWithTimeIntervalSinceReferenceDate:reward.availableUntil]
//																												 options:0];
		
//		NSInteger days = [components day];
		
		NSTimeInterval interval = [[NSDate dateWithTimeIntervalSince1970:reward.availableUntil] timeIntervalSinceDate:[NSDate date]];
		int intervalHours = interval/60/60;
		int intervalDays = interval/60/60/24;
		
		
		
		if (intervalDays > 1) {
			expiresString = [NSString stringWithFormat:@"Draw takes place in %ld days.",(long)intervalDays];
		}
		if (intervalDays == 1) {
			expiresString = @"Draw takes place in 1 day.";
		}
		if (intervalDays == 0) {
			
			if (intervalHours == 0) {
				expiresString = @"Draw has happened. You will be notified if you are the winner.";
			} else {
				expiresString = [NSString stringWithFormat:@"Draw takes place in %ld hours",(long)intervalHours];
			}
		}
		return expiresString;
	}
	return @"";
}

- (void) rotateArrowDown {
	[UIView animateWithDuration:0.5
												delay:0.0
											options: UIViewAnimationOptionCurveEaseInOut
									 animations:^{
										 self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
									 }
									 completion:^(BOOL finished){
									 }];
}

- (void) rotateArrowRight {
	[UIView animateWithDuration:0.5
												delay:0.0
											options: UIViewAnimationOptionCurveEaseInOut
									 animations:^{
										 self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
									 }
									 completion:^(BOOL finished){
									 }];
	
}

@end
