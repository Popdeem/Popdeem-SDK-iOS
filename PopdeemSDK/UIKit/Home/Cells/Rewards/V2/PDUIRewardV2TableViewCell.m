//
//  PDUIRewardV2TableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/01/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDUIRewardV2TableViewCell.h"
#import "PDReward.h"
#import "PDTheme.h"
#import "PDBrandTheme.h"
#import "PDUtils.h"
#import <UIKit/UIKit.h>

@interface PDUIRewardV2TableViewCell()
  @property (nonatomic, retain) UIColor *primaryAppColor;
  @property (nonatomic, retain) UIColor *primaryFontColor;
  @property (nonatomic, retain) UIColor *secondaryFontColor;
  @property (nonatomic, retain) UIColor *secondaryAppColor;
  @property (nonatomic, retain) UIColor *tertiaryFontColor;
  @property (nonatomic, retain) UIColor *cellBackgroundColor;
  @property (nonatomic, assign) PDBrandTheme *brandTheme;
@end

@implementation PDUIRewardV2TableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  [_label setFont:PopdeemFont(PDThemeFontPrimary, 14)];
  [_label setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
  
  [self setBackgroundColor:[UIColor clearColor]];
  if (PopdeemThemeHasValueForKey(PDThemeColorTableViewCellBackground)) {
    [self setBackgroundColor:PopdeemColor(PDThemeColorTableViewCellBackground)];
    self.contentView.backgroundColor = PopdeemColor(PDThemeColorTableViewCellBackground);
  }
}

- (id) initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    return self;
  }
  return nil;
}

- (void) setupForReward:(PDReward *)reward theme:(PDBrandTheme*)theme {
  _brandTheme = theme;
  [self setupForReward:reward];
}

- (void) setupForReward:(PDReward*)reward {
  [self setBackgroundColor:[UIColor clearColor]];
  if (_brandTheme) {
    _primaryAppColor = PopdeemColorFromHex(_brandTheme.primaryAppColor);
    _primaryFontColor = PopdeemColorFromHex(_brandTheme.primaryTextColor);
    _secondaryFontColor = PopdeemColorFromHex(_brandTheme.secondaryTextColor);
  } else {
    _primaryAppColor = PopdeemColor(PDThemeColorPrimaryApp);
    _primaryFontColor = PopdeemColor(PDThemeColorPrimaryFont);
    _secondaryFontColor = PopdeemColor(PDThemeColorSecondaryFont);
    _secondaryAppColor = PopdeemColor(PDThemeColorPrimaryApp);
    if ([PDTheme.sharedInstance hasValueForKey:PDThemeColorTertiaryFont]) {
      _tertiaryFontColor = PopdeemColor(PDThemeColorTertiaryFont);
    } else {
      _tertiaryFontColor = PopdeemColor(PDThemeColorPrimaryApp);
    }
  }
  
  [self setBackgroundColor:[UIColor clearColor]];
  [self.contentView setBackgroundColor:[UIColor clearColor]];
  
  float sideIndent = 20;
  float topIndent = 10;
  _backingCard.backgroundColor = [UIColor whiteColor];
  _backingCard.layer.cornerRadius = 5.0;
  _backingCard.clipsToBounds = YES;
  _backingCard.layer.shadowOffset = CGSizeMake(0, 0); //default is (0.0, -3.0)
  _backingCard.layer.shadowColor = [UIColor grayColor].CGColor; //default is black
  _backingCard.layer.shadowRadius = 3.0; //default is 3.0
  _backingCard.layer.shadowOpacity = 0.5;
  _backingCard.layer.masksToBounds = NO;

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
  [self.rewardImageView setContentMode:UIViewContentModeScaleAspectFit];
  
  NSString *description = reward.rewardDescription;
  NSString *rules = reward.rewardRules;

  NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
  ps.paragraphSpacing = 2.0;
  ps.lineSpacing = 0;
  NSMutableAttributedString *labelAttString = [[NSMutableAttributedString alloc] initWithString:@""
                                                                                     attributes:@{}];
  
  NSMutableParagraphStyle *innerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
  innerParagraphStyle.lineSpacing = 0;
  
  
  NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc]
                                                  initWithString:[NSString stringWithFormat:@"%@ \n",description]
                                                  attributes:@{
                                                               NSFontAttributeName : PopdeemFont(PDThemeFontBold, 14),
                                                               NSForegroundColorAttributeName : _primaryFontColor
                                                               }];
  
  [labelAttString appendAttributedString:descriptionString];
  
  if (rules.length > 0) {
    NSMutableAttributedString *rulesString = [[NSMutableAttributedString alloc]
                                              initWithString:[NSString stringWithFormat:@"%@ \n",rules]
                                              attributes:@{
                                                           NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
                                                           NSForegroundColorAttributeName : _secondaryFontColor
                                                           }];
    [labelAttString appendAttributedString:rulesString];
  }
  
  [_label setAttributedText:labelAttString];
  
  CALayer *topBorder = [CALayer layer];
  topBorder.frame = CGRectMake(0.0f, 0.0f, _backingCard.frame.size.width, 0.5f);
  topBorder.backgroundColor = [UIColor grayColor].CGColor;
  [_infoArea.layer addSublayer:topBorder];
  
  NSString *info = [self infoStringForReward:reward];
  NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc]
                                           initWithString:info attributes:@{
                                                                            NSFontAttributeName : PopdeemFont(PDThemeFontLight, 12),
                                                                            NSForegroundColorAttributeName : PopdeemColor(PDThemeColorSecondaryFont)
                                                                            }];
  [_actionLabel setAttributedText:infoString];
  
  NSString *exp = [self expiryStringForReward:reward];
  NSMutableAttributedString *expiryString = [[NSMutableAttributedString alloc]
                                           initWithString:exp attributes:@{
                                                                            NSFontAttributeName : PopdeemFont(PDThemeFontLight, 12),
                                                                            NSForegroundColorAttributeName : PopdeemColor(PDThemeColorSecondaryFont)
                                                                            }];
  [_expiryLabel setAttributedText:expiryString];
  
}

- (NSString*) infoStringForReward:(PDReward*)reward {
  NSString *action;
  
  NSArray *types = reward.socialMediaTypes;
  if (types.count > 0) {
    if (types.count > 1) {
      //Both Networks
      switch (reward.action) {
        case PDRewardActionCheckin:
          action = translationForKey(@"popdeem.claim.action.checkinOrTweet", @"Check-in or Tweet Required");
          break;
        case PDRewardActionPhoto:
          action = translationForKey(@"popdeem.claim.action.photo", @"📸 Photo Required");
          break;
        case PDRewardActionNone:
          action = translationForKey(@"popdeem.claim.action.noAction", @"No Action Required");
        default:
          action = translationForKey(@"popdeem.claim.action.noAction", @"No Action Required");
          break;
      }
    } else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeFacebook)]) {
      //Facebook Only
      switch (reward.action) {
        case PDRewardActionCheckin:
          action = translationForKey(@"popdeem.claim.action.checkin", @"Check-in Required");
          break;
        case PDRewardActionPhoto:
          action = translationForKey(@"popdeem.claim.action.photo", @"Photo Required");
          break;
        case PDRewardActionNone:
          action = translationForKey(@"popdeem.claim.action.noAction", @"No Action Required");
        default:
          action = translationForKey(@"popdeem.claim.action.noAction", @"No Action Required");
          break;
      }
    } else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeTwitter)]) {
      //Twitter Only
      switch (reward.action) {
        case PDRewardActionCheckin:
          action = translationForKey(@"popdeem.claim.action.tweet", @"Tweet Required");
          break;
        case PDRewardActionPhoto:
          action = translationForKey(@"popdeem.claim.action.photo", @"Photo Required");
          break;
        case PDRewardActionNone:
          action = translationForKey(@"popdeem.claim.action.noAction", @"No Action Required");
        default:
          action = translationForKey(@"popdeem.claim.action.noAction", @"No Action Required");
          break;
      }
    } else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeInstagram)]) {
      //Twitter Only
      action = translationForKey(@"popdeem.claim.action.photo", @"Photo Required");
      
    }
  } else if (types.count == 0) {
    switch (reward.action) {
      case PDRewardActionCheckin:
        action = translationForKey(@"popdeem.claim.action.checkin", @"Check-in Required");
        break;
      case PDRewardActionPhoto:
        action = translationForKey(@"popdeem.claim.action.photo", @"Photo Required");
        break;
      case PDRewardActionNone:
        action = translationForKey(@"popdeem.claim.action.noAction", @"No Action Required");
      default:
        action = translationForKey(@"popdeem.claim.action.noAction", @"No Action Required");
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
  
  return [NSString stringWithFormat:@"%@",action];
  
}

- (NSString *) expiryStringForReward:(PDReward*)reward {
  
  if (reward.unlimitedAvailability) {
    return @"";
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
    int intervalWeeks = interval/60/60/24/7;
    int intervalMonths = interval/60/60/24/7;
    
    
    if (intervalMonths > 0) {
      if (intervalMonths > 1) {
        exp = [NSString stringWithFormat:@"🕐 %ld months remaining",intervalMonths];
      } else {
       exp = [NSString stringWithFormat:@"🕐 %ld month remaining",intervalMonths];
      }
    } else if (intervalDays > 6) {
      exp = [NSString stringWithFormat:@"🕐 %ld weeks remaining",intervalWeeks];
    } else if (intervalDays < 7 && intervalHours > 23) {
      exp = [NSString stringWithFormat:@"🕐 %ld days remaining.",(long)intervalDays];
    } else {
      exp = [NSString stringWithFormat:@"🕐 %ld hours remaining.",(long)intervalHours];
    }
  }
  
  return exp;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
