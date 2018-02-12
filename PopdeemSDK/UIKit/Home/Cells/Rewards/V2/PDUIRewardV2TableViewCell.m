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
#import "PopdeemSDK.h"

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

+ (PDUIRewardV2TableViewCell *)cellFromNibNamed:(NSString *)nibName {
  NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
  NSArray *nibContents = [podBundle loadNibNamed:nibName owner:self options:NULL];
  NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
  PDUIRewardV2TableViewCell *customCell = nil;
  NSObject* nibItem = nil;
  while ((nibItem = [nibEnumerator nextObject]) != nil) {
    if ([nibItem isKindOfClass:[PDUIRewardV2TableViewCell class]]) {
      customCell = (PDUIRewardV2TableViewCell *)nibItem;
      break; // we have a winner
    }
  }
  return customCell;
}

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
  ps.paragraphSpacing = 8.0;
  ps.lineSpacing = 0;
  
  NSMutableAttributedString *labelAttString = [[NSMutableAttributedString alloc] initWithString:@""
                                                                                     attributes:@{NSParagraphStyleAttributeName: ps}];
  
  NSMutableParagraphStyle *innerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
  innerParagraphStyle.lineSpacing = 0;
  
  
  NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc]
                                                  initWithString:[NSString stringWithFormat:@"%@ \n",description]
                                                  attributes:@{
                                                               NSFontAttributeName : PopdeemFont(PDThemeFontBold, 14),
                                                               NSForegroundColorAttributeName : _primaryFontColor, NSParagraphStyleAttributeName: innerParagraphStyle
                                                               }];
  
  [labelAttString appendAttributedString:descriptionString];
  
  if (rules.length > 0) {
    NSMutableAttributedString *rulesString = [[NSMutableAttributedString alloc]
                                              initWithString:[NSString stringWithFormat:@"%@",rules]
                                              attributes:@{
                                                           NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
                                                           NSForegroundColorAttributeName : _secondaryFontColor,
                                                           NSParagraphStyleAttributeName: innerParagraphStyle
                                                           }];
    [labelAttString appendAttributedString:rulesString];
  }
  
  NSString *info = [self expiryStringForReward:reward];
  info = [@"\n" stringByAppendingString:info];
  UIColor *bottomTextColor = _tertiaryFontColor ? _tertiaryFontColor : _primaryAppColor;
  NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc]
                                           initWithString:info attributes:@{
                                                                            NSFontAttributeName : PopdeemFont(PDThemeFontBold, 12),
                                                                            NSForegroundColorAttributeName : bottomTextColor
                                                                            }];
  
  [labelAttString appendAttributedString:infoString];
  
  [labelAttString addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, labelAttString.length)];
  
  [_label setAttributedText:labelAttString];
  
  CALayer *topBorder = [CALayer layer];
  topBorder.frame = CGRectMake(0.0f, 0.0f, _backingCard.frame.size.width, 0.5f);
  topBorder.backgroundColor = [UIColor grayColor].CGColor;
  [_infoArea.layer addSublayer:topBorder];
  
  NSString *action = [self infoStringForReward:reward];
  NSMutableAttributedString *actionString = [[NSMutableAttributedString alloc]
                                           initWithString:action attributes:@{
                                                                            NSFontAttributeName : PopdeemFont(PDThemeFontLight, 12),
                                                                            NSForegroundColorAttributeName : PopdeemColor(PDThemeColorSecondaryFont)
                                                                            }];
  [_actionLabel setAttributedText:actionString];
  
  NSString *exp = [self expiryStringForReward:reward];
  NSMutableAttributedString *expiryString = [[NSMutableAttributedString alloc]
                                           initWithString:exp attributes:@{
                                                                            NSFontAttributeName : PopdeemFont(PDThemeFontLight, 12),
                                                                            NSForegroundColorAttributeName : PopdeemColor(PDThemeColorSecondaryFont)
                                                                            }];
  [_expiryLabel setAttributedText:expiryString];
  
  if (reward.socialMediaTypes.count == 3) {
    //Three Social Icons
    [_socialIconOne setImage:PopdeemImage(@"pduirewardtwittericon")];
    [_socialIconTwo setImage:PopdeemImage(@"pduirewardinstagramicon")];
    [_socialIconThree setImage:PopdeemImage(@"pduirewardfacebookicon")];
    [_socialIconOne setHidden:NO];
    [_socialIconTwo setHidden:NO];
    [_socialIconThree setHidden:NO];
  } else if (reward.socialMediaTypes.count == 2) {
    if ([reward.socialMediaTypes[0] isEqualToNumber:@(PDSocialMediaTypeFacebook)]) {
      [_socialIconOne setImage:PopdeemImage(@"pduirewardfacebookicon")];
      [_socialIconOne setHidden:NO];
    } else if ([reward.socialMediaTypes[0] isEqualToNumber:@(PDSocialMediaTypeTwitter)]) {
      [_socialIconOne setImage:PopdeemImage(@"pduirewardtwittericon")];
      [_socialIconOne setHidden:NO];
    } else if ([reward.socialMediaTypes[0] isEqualToNumber:@(PDSocialMediaTypeInstagram)]) {
      [_socialIconOne setImage:PopdeemImage(@"pduirewardfacebookicon")];
      [_socialIconOne setHidden:NO];
    }
    if ([reward.socialMediaTypes[1] isEqualToNumber:@(PDSocialMediaTypeFacebook)]) {
      [_socialIconTwo setImage:PopdeemImage(@"pduirewardfacebookicon")];
      [_socialIconTwo setHidden:NO];
    } else if ([reward.socialMediaTypes[1] isEqualToNumber:@(PDSocialMediaTypeTwitter)]) {
      [_socialIconTwo setImage:PopdeemImage(@"pduirewardtwittericon")];
      [_socialIconTwo setHidden:NO];
    } else if ([reward.socialMediaTypes[1] isEqualToNumber:@(PDSocialMediaTypeInstagram)]) {
      [_socialIconTwo setImage:PopdeemImage(@"pduirewardfacebookicon")];
      [_socialIconTwo setHidden:NO];
    }
  } else if (reward.socialMediaTypes.count == 1) {
    if ([reward.socialMediaTypes[0] isEqualToNumber:@(PDSocialMediaTypeFacebook)]) {
      [_socialIconOne setImage:PopdeemImage(@"pduirewardfacebookicon")];
      [_socialIconOne setHidden:NO];
    } else if ([reward.socialMediaTypes[0] isEqualToNumber:@(PDSocialMediaTypeTwitter)]) {
      [_socialIconOne setImage:PopdeemImage(@"pduirewardtwittericon")];
      [_socialIconOne setHidden:NO];
    } else if ([reward.socialMediaTypes[0] isEqualToNumber:@(PDSocialMediaTypeInstagram)]) {
      [_socialIconOne setImage:PopdeemImage(@"pduirewardfacebookicon")];
      [_socialIconOne setHidden:NO];
    }
  }
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
        exp = [NSString stringWithFormat:@"🕐 %ld months left to claim.",intervalMonths];
      } else {
       exp = [NSString stringWithFormat:@"🕐 %ld month left to claim.",intervalMonths];
      }
    } else if (intervalDays > 6) {
      exp = [NSString stringWithFormat:@"🕐 %ld weeks left to claim.",intervalWeeks];
    } else if (intervalDays < 7 && intervalHours > 23) {
      exp = [NSString stringWithFormat:@"🕐 %ld days left to claim.",(long)intervalDays];
    } else {
      exp = [NSString stringWithFormat:@"🕐 %ld hours left to claim.",(long)intervalHours];
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
