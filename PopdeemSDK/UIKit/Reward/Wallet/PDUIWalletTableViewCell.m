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
  frame.size = CGSizeMake(frame.size.width, frame.size.height+190);
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  if (self = [super initWithFrame:frame]) {
    float visibleHeight = 65;
    self.clipsToBounds = YES;
    
    if (!reward) {
      return nil;
    }
    
    float imageSize = visibleHeight * 0.60;
    float indent = visibleHeight *0.20;
    [self setBackgroundColor:[UIColor clearColor]];
    if (PopdeemThemeHasValueForKey(@"popdeem.home.tableView.walletCell.backgroundColor")) {
      [self setBackgroundColor:PopdeemColor(@"popdeem.home.tableView.walletCell.backgroundColor")];
    }
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(indent, indent, imageSize, imageSize)];
    [self.logoImageView setClipsToBounds:YES];
    [self addSubview:_logoImageView];
    if (reward.coverImage) {
      [self.logoImageView setImage:reward.coverImage];
    } else {
      [self.logoImageView setImage:[UIImage imageNamed:@"pduikit_starG"]];
    }
    [self.logoImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.logoImageView.layer.cornerRadius = imageSize/2;
    float centerY = visibleHeight/2;
    float viewWidth = frame.size.width;
    float arrowSize = 30;
    float labelWidth = viewWidth-indent-indent-imageSize-arrowSize;
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(indent+imageSize+indent, centerY-20, labelWidth, 40)];
    _descriptionLabel.numberOfLines = 2;
    [self addSubview:_descriptionLabel];
    [_descriptionLabel setFont:PopdeemFont(@"popdeem.home.tableView.walletCell.fontName", 14)];
    [_descriptionLabel setTextColor:PopdeemColor(@"popdeem.home.tableView.walletCell.titleTextColor")];
    
    if (![reward.rewardDescription isKindOfClass:[NSNull class]]) {
      if (reward.type == PDRewardTypeCredit) {
        [self.descriptionLabel setText:[NSString stringWithFormat:translationForKey(@"popdeem.wallet.creditRewardText", @"%@ was added to your balance."), reward.creditString]];
      } else {
        [self.descriptionLabel setText:reward.rewardDescription];
      }
    }
    
    if (reward.type != PDRewardTypeCredit) {
      _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-35, centerY-10, 20, 20)];
      [_arrowImageView setImage:[UIImage imageNamed:@"pduikit_popdeemArrowB"]];
      [self addSubview:_arrowImageView];
    }
    
    switch (reward.type) {
      case PDRewardTypeSweepstake:
        [self.redeemLabel setText:translationForKey(@"popdeem.wallet.sweepstake.redeemText", @"You will be notified if you are the winner.")];
        break;
      case PDRewardTypeCredit:
        [self.redeemLabel setText:translationForKey(@"popdeem.wallet.coupon.redeemText", @"Redeem at the point of sale.")];
        break;
      case PDRewardTypeCoupon:
      case PDRewardTypeInstant:
        [self.redeemLabel setText:translationForKey(@"popdeem.wallet.coupon.redeemText", @"Redeem at the point of sale.")];
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
    
    UIView *backingView = [[UIView alloc] initWithFrame:CGRectMake(0, visibleHeight, viewWidth, 190)];
    [backingView setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.000]];
    [self addSubview:backingView];
    
    UILabel *howToTitle = [[UILabel alloc] initWithFrame:CGRectMake(indent, 5, viewWidth-2*indent, 20)];
    [howToTitle setFont:PopdeemFont(@"popdeem.home.tableView.walletCell.fontName", 14)];
    [howToTitle setTextColor:[UIColor blackColor]];
    [backingView addSubview:howToTitle];
    
    UILabel *howToLabel = [[UILabel alloc] initWithFrame:CGRectMake(indent+5, 25, viewWidth-(2*indent)-5, 190-120)];
    [howToLabel setFont:PopdeemFont(@"popdeem.home.tableView.walletCell.fontName", 12)];
    [howToLabel setTextColor:[UIColor blackColor]];
    [howToLabel setNumberOfLines:6];
    howToLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if (reward.type == PDRewardTypeCoupon || reward.type == PDRewardTypeInstant || reward.type == PDRewardTypeCredit) {
      [howToTitle setText:@"How to Redeem"];
      [howToLabel setText:[NSString stringWithFormat:translationForKey(@"popdeem.wallet.coupon.infoText", @"- Once you're ready to redeem your Reward, tap \"Redeem\".\n- After tapping \"Redeem\" you have 10 minutes to get the Reward.\n- You must show the cashier the following screen within 10 minutes.\n- %@"), expiresString]];
    } else {
      [howToTitle setText:@"Sweepstake Reward"];
      [howToLabel setText:[NSString stringWithFormat:@"You are now in the draw!\nYou will be notified if you are the winner.\n%@.",expiresString]];
      
    }
    [howToLabel sizeToFit];
    [backingView addSubview:howToLabel];
    
    if (reward.type == PDRewardTypeCoupon  || reward.type == PDRewardTypeInstant) {
      UIButton *redeemButton = [[UIButton alloc] initWithFrame:CGRectMake(30, backingView.frame.size.height-45, viewWidth-60, 40)];
      [redeemButton setBackgroundColor:PopdeemColor(@"popdeem.redeem.redeemButton.backgroundColor")];
      [redeemButton setTitleColor:PopdeemColor(@"popdeem.redeem.redeemButton.fontColor") forState:UIControlStateNormal];
      [redeemButton.titleLabel setFont:PopdeemFont(@"popdeem.home.tableView.walletCell.fontName", 16)];
      [redeemButton setTitle:@"Redeem" forState:UIControlStateNormal];
      [redeemButton addTarget:parent action:@selector(redeemButtonPressed) forControlEvents:UIControlEventTouchUpInside];
      [backingView addSubview:redeemButton];
    }
    
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
