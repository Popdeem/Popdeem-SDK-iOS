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

- (void) setupForReward:(PDReward*)reward {
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
			labelLineTwo = [NSString stringWithFormat:@"Redeemed: %@",stringDate];
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
						NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
				}];
	
	[labelAttString appendAttributedString:descriptionString];

	NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc]
			initWithString:labelLineTwo
				attributes:@{
						NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
						NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryApp)
				}];
	
	[labelAttString appendAttributedString:infoString];
	NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
	ps.lineSpacing = 2.0;
	[labelAttString addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, labelAttString.length)];
	[_mainLabel setAttributedText:labelAttString];
	
	float centerY = self.frame.size.height/2;
	
	_arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-25, centerY-10, 20, 20)];
	[_arrowImageView setImage:[UIImage imageNamed:@"arrowB"]];
	[self addSubview:_arrowImageView];
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
