//
//  WalletTableViewCell.m
//  ios-test-v0.2
//
//  Created by Niall Quinn on 09/10/2014.
//  Copyright (c) 2014 Niall Quinn. All rights reserved.
//

#import "PDUIWalletTableViewCell.h"
#import "PDUIWalletCache.h"
#import "PDTheme.h"
#import "PDUtils.h"


@implementation PDUIWalletTableViewCell

- (PDUIWalletTableViewCell*) initWithFrame:(CGRect)frame reward:(PDReward*)reward parent:(PDUIHomeViewController*)parent {
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  if (self = [super initWithFrame:frame]) {
    float visibleHeight = 85;
    self.clipsToBounds = YES;
    
    if (!reward) {
      return nil;
    }
    
    float imageSize = visibleHeight * 0.60;
    float indent = visibleHeight *0.20;
    [self setBackgroundColor:[UIColor clearColor]];
    if (PopdeemThemeHasValueForKey(@"popdeem.colors.tableViewCellBackgroundColor")) {
      [self setBackgroundColor:PopdeemColor(@"popdeem.colors.tableViewCellBackgroundColor")];
    }
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(indent, indent, imageSize, imageSize)];
    [self.logoImageView setClipsToBounds:YES];
    [self addSubview:_logoImageView];
    if (reward.coverImage) {
      [self.logoImageView setImage:reward.coverImage];
    } else {
      [self.logoImageView setImage:PopdeemImage(@"popdeem.images.defaultItemImage")];
    }
    [self.logoImageView setContentMode:UIViewContentModeScaleAspectFit];
    float centerY = visibleHeight/2;
    float viewWidth = frame.size.width;
    float arrowSize = 30;
    float labelWidth = viewWidth-indent-indent-imageSize-arrowSize;
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(indent+imageSize+indent, 0, labelWidth, 40)];
    _descriptionLabel.numberOfLines = 2;
    [_descriptionLabel setFont:PopdeemFont(@"popdeem.fonts.boldFont", 14)];
    [_descriptionLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryFontColor")];
    [self addSubview:_descriptionLabel];
		
		
		_subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(indent+imageSize+indent, _descriptionLabel.frame.size.height, labelWidth, 40)];
		_subtitleLabel.numberOfLines = 2;
		[_subtitleLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 12)];
		[_subtitleLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
		[self addSubview:_subtitleLabel];
		
    
    if (![reward.rewardDescription isKindOfClass:[NSNull class]]) {
      if (reward.type == PDRewardTypeCredit) {
        [self.descriptionLabel setText:[NSString stringWithFormat:translationForKey(@"popdeem.wallet.creditRewardText", @"%@ was added to your balance."), reward.creditString]];
      } else {
        [self.descriptionLabel setText:reward.rewardDescription];
      }
    }
    
    if (reward.type == PDRewardTypeCredit || reward.type == PDRewardTypeSweepstake) {
      self.userInteractionEnabled = NO;
    }
		NSDate *creditDate;
		NSDateFormatter *formatter;
		NSString *stringDate;
		
    switch (reward.type) {
      case PDRewardTypeSweepstake:
        [self.subtitleLabel setText:translationForKey(@"popdeem.wallet.sweepstake.redeemText", @"You have been entered in this competition.")];
        break;
      case PDRewardTypeCredit:
				creditDate = [NSDate dateWithTimeIntervalSince1970:reward.claimedAt];
				formatter = [[NSDateFormatter alloc] init];
				[formatter setDateFormat:@"d MMM y"];
				stringDate = [formatter stringFromDate:creditDate];
				[_subtitleLabel setText:[NSString stringWithFormat:@"Redeemed: %@",stringDate]];
        break;
      case PDRewardTypeCoupon:
      case PDRewardTypeInstant:
        [self.subtitleLabel setText:translationForKey(@"popdeem.wallet.coupon.redeemText", @"Redeem at the point of sale.")];
        break;
    }
		
    NSString *expiresString;
    if (reward.unlimitedAvailability) {
      if (reward.type == PDRewardTypeSweepstake) {
        expiresString = translationForKey(@"popdeem.wallet.unlimitedReward.sweepstake.expiryString", @"There is no date set for this draw.");
      } else {
        expiresString = translationForKey(@"popdeem.wallet.unlimitedReward.coupon.expiryString", @"This reward has no expiry date.");
      }
    } else {
      NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
      NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                          fromDate:[NSDate date]
                                                            toDate:[NSDate dateWithTimeIntervalSinceReferenceDate:reward.availableUntil]
                                                           options:0];
      
      NSInteger days = [components day];
      
      NSTimeInterval interval = [[NSDate dateWithTimeIntervalSince1970:reward.availableUntil] timeIntervalSinceDate:[NSDate date]];
      int intervalHours = interval/60/60;
      int intervalDays = interval/60/60/24;
      
      if (intervalDays > 1) {
        if (reward.type == PDRewardTypeSweepstake) {
          expiresString = [NSString stringWithFormat:@"Draw in %ld days",(long)intervalDays];
        } else {
          expiresString = [NSString stringWithFormat:@"Expires in %ld days",(long)intervalDays];
        }
      }
      if (intervalDays == 1) {
        expiresString = @"Expires in 1 day";
        if (reward.type == PDRewardTypeSweepstake) {
          expiresString = @"Draw in 1 day";
        } else {
          expiresString = @"Expires in 1 day";
        }
      }
      if (intervalDays == 0) {
        
        if (intervalHours == 0) {
          if (reward.type == PDRewardTypeSweepstake) {
            expiresString = @"Draw has happened. Standy by.";
          } else {
            expiresString = @"Expired";
          }
        } else {
          if (reward.type == PDRewardTypeSweepstake) {
            expiresString = [NSString stringWithFormat:@"Draw in %ld hours",(long)intervalHours];
          } else {
            expiresString = [NSString stringWithFormat:@"Expires in %ld hours",(long)intervalHours];
          }
        }
      }
    }
		

		[_descriptionLabel sizeToFit];
		[_subtitleLabel sizeToFit];
		
		float buffer = 5;
		float labelsJoined = _descriptionLabel.frame.size.height + _subtitleLabel.frame.size.height + buffer;
		float paddingTop = (frame.size.height - labelsJoined)/2;
		[_descriptionLabel setFrame:CGRectMake(_descriptionLabel.frame.origin.x, paddingTop, labelWidth, _descriptionLabel.frame.size.height)];
		[_subtitleLabel setFrame:CGRectMake(_subtitleLabel.frame.origin.x, paddingTop+_descriptionLabel.frame.size.height+5, labelWidth, _subtitleLabel.frame.size.height)];
    return self;
  }
  return nil;
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  //    [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
  //    float alpha = (selected) ? 0.5 : 1.0;
  //    [self.bgView setAlpha:alpha];
  
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
