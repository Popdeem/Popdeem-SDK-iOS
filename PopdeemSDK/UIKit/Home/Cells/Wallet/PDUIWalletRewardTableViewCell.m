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
	[_titleLabel setFont:PopdeemFont(PDThemeFontBold, 14)];
	[_titleLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
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
	
	[_titleLabel setTextColor:_primaryFontColor];
	[self.arrowImageView setHidden:NO];
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
      [self.arrowImageView setHidden:NO];
			break;
    case PDRewardTypeCredit:
		case PDRewardTypeCoupon:
		case PDRewardTypeInstant:
      if (reward.creditString.length > 0) {
        creditDate = [NSDate dateWithTimeIntervalSince1970:reward.claimedAt];
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"d MMM"];
        stringDate = [formatter stringFromDate:creditDate];
        labelLineTwo = [NSString stringWithFormat:translationForKey(@"popdeem.wallet.creditString", @"%@ was added to your account on %@"),reward.creditString, stringDate];
        [self.arrowImageView setHidden:YES];
      } else {
        [self.arrowImageView setHidden:NO];
        labelLineTwo = translationForKey(@"popdeem.wallet.coupon.redeemText", @"Redeem at the point of sale.");
      }
			break;
	}
	
	NSMutableAttributedString *labelAttString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{}];
	
	NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc]
			initWithString:[NSString stringWithFormat:@"%@",reward.rewardDescription]
				attributes:@{
						NSFontAttributeName : PopdeemFont(PDThemeFontBold, 14),
						NSForegroundColorAttributeName : _primaryFontColor
				}];
	
	[labelAttString appendAttributedString:descriptionString];

  float labelx = _rewardImageView.frame.size.width + 16;
  float labelWidth = self.frame.size.width - labelx - _arrowImageView.frame.size.width - 24;
  CGRect titleLabelRect = CGRectMake(labelx, 0,labelWidth , 50);
  if (_titleLabel == nil) {
    _titleLabel = [[UILabel alloc] initWithFrame:titleLabelRect];
    [self addSubview:_titleLabel];
  } else {
    [_titleLabel setFrame:titleLabelRect];
  }
  [_titleLabel setNumberOfLines:3];
  [_titleLabel setAttributedText:labelAttString];
  [_titleLabel setContentMode:UIViewContentModeCenter];
  [_titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
  
  CGSize size = [_titleLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
  CGRect labelFrame = _titleLabel.frame;
  labelFrame.size.height = size.height;
  _titleLabel.frame = labelFrame;
  _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  float innerSpacing = 3;
  
  float currentY = _titleLabel.frame.size.height + innerSpacing;
  
	NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc]
			initWithString:labelLineTwo
				attributes:@{
						NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
						NSForegroundColorAttributeName : _primaryAppColor
				}];
	
	NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
	ps.lineSpacing = 2.0;
	[infoString addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, infoString.length)];

	CGRect infoLabelRect = CGRectMake(labelx, _titleLabel.frame.size.height ,labelWidth , 50);
  if (_infoLabel == nil) {
    _infoLabel = [[UILabel alloc] initWithFrame:infoLabelRect];
    [self addSubview:_infoLabel];
  } else {
    [_infoLabel setFrame:infoLabelRect];
  }
  [_infoLabel setNumberOfLines:2];
  [_infoLabel setAttributedText:infoString];
  CGSize infoSize = [_infoLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
  CGRect infoLabelFrame = _infoLabel.frame;
  infoLabelFrame.size.height = infoSize.height;
  _infoLabel.frame = infoLabelFrame;
  currentY += _infoLabel.frame.size.height;
  _infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	
  currentY += innerSpacing;
  
  float combinedHeight = currentY;
  float padding = 100 - combinedHeight;
  float topPadding = padding/2;
	
  currentY = topPadding;
  [_titleLabel setFrame:CGRectMake(labelx, currentY, _titleLabel.frame.size.width, _titleLabel.frame.size.height)];
  currentY += _titleLabel.frame.size.height + innerSpacing;
  [_infoLabel setFrame:CGRectMake(labelx, currentY, _infoLabel.frame.size.width, _infoLabel.frame.size.height)];
  
  
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
  if (reward.recurrence) {
    if ([reward.recurrence isEqualToString:@"Monthly"]) {
      return @"Draw takes place monthly.";
    } else {
      NSString *cap = [reward.recurrence capitalizedString];
      return [NSString stringWithFormat:@"Draw takes place on %@", cap];
    }
  } else if (reward.availableUntil) {
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
