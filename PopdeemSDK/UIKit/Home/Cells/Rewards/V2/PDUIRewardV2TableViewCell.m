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
  
  
  NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc]
                                                  initWithString:[NSString stringWithFormat:@"%@",description]
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
  
  
  
  [labelAttString addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, labelAttString.length)];
  
  //Do the label spacing
  //Title Label
  float innerSpacing = 3;
  float labelX = self.rewardImageView.frame.size.width + 30;
  if (_titleLabel == nil) {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, _backingCard.frame.size.width - labelX - 15, 60)];
    [_backingCard addSubview:_titleLabel];
  } else {
    [_titleLabel setFrame:CGRectMake(labelX, 0, _backingCard.frame.size.width - labelX - 15, 60)];
  }
  
  
  [_titleLabel setNumberOfLines:2];
  [_titleLabel setAttributedText:descriptionString];
  [_titleLabel setContentMode:UIViewContentModeCenter];
  [_titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
  
  CGSize size = [_titleLabel sizeThatFits:CGSizeMake(_backingCard.frame.size.width - labelX - 15, MAXFLOAT)];
  CGRect labelFrame = _titleLabel.frame;
  labelFrame.size.height = size.height;
  _titleLabel.frame = labelFrame;
  _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  
  float currentY = _titleLabel.frame.size.height + innerSpacing;
  
  //Rules Label
  if (rules.length > 0) {
    NSMutableAttributedString *rulesString = [[NSMutableAttributedString alloc]
                                              initWithString:[NSString stringWithFormat:@"%@",rules]
                                              attributes:@{
                                                           NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
                                                           NSForegroundColorAttributeName : _secondaryFontColor,
                                                           NSParagraphStyleAttributeName: innerParagraphStyle
                                                           }];
    [labelAttString appendAttributedString:rulesString];
    if (_infoLabel == nil) {
      _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, currentY, _backingCard.frame.size.width - labelX - 15, 60)];
      [_backingCard addSubview:_infoLabel];
    } else {
      [_infoLabel setFrame:CGRectMake(labelX, currentY, _backingCard.frame.size.width - labelX - 15, 60)];
    }
    [_infoLabel setNumberOfLines:4];
    [_infoLabel setAttributedText:rulesString];
    CGSize infoSize = [_infoLabel sizeThatFits:CGSizeMake(_backingCard.frame.size.width - labelX - 15, MAXFLOAT)];
    CGRect infoLabelFrame = _infoLabel.frame;
    infoLabelFrame.size.height = infoSize.height;
    _infoLabel.frame = infoLabelFrame;
    currentY += _infoLabel.frame.size.height;
    _infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  } else {
    [_infoLabel removeFromSuperview];
    _infoLabel = nil;
  }
  
  currentY += innerSpacing;
  
  
  NSString *info = [self expiryStringForReward:reward];
  if (info != nil) {
    UIColor *bottomTextColor = _tertiaryFontColor ? _tertiaryFontColor : _primaryAppColor;
    NSMutableAttributedString *clockString = [[NSMutableAttributedString alloc]
                                              initWithString:@"⌚︎ " attributes:@{
                                                                                 NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 14),
                                                                                 NSForegroundColorAttributeName : bottomTextColor
                                                                                 }];
    NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc]
                                             initWithString:info attributes:@{
                                                                              NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 10),
                                                                              NSForegroundColorAttributeName : bottomTextColor
                                                                              }];
    
  
    NSMutableAttributedString *combinedString = [[NSMutableAttributedString alloc] init];
    [combinedString appendAttributedString:clockString];
    [combinedString appendAttributedString:infoString];
    
    if (_expiryLabel == nil) {
      _expiryLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, currentY, _backingCard.frame.size.width - labelX - 15, 60)];
      [_backingCard addSubview:_expiryLabel];
    } else {
      [_expiryLabel setFrame:CGRectMake(labelX, currentY, _backingCard.frame.size.width - labelX - 15, 60)];
    }
    [_expiryLabel setNumberOfLines:1];
    [_expiryLabel setAttributedText:combinedString];
    CGSize expirySize = [_expiryLabel sizeThatFits:CGSizeMake(_backingCard.frame.size.width - labelX - 15, MAXFLOAT)];
    CGRect expiryLabelFrame = _expiryLabel.frame;
    expiryLabelFrame.size.height = expirySize.height;
    _expiryLabel.frame = expiryLabelFrame;
    currentY += _expiryLabel.frame.size.height;
  } else {
    [_expiryLabel removeFromSuperview];
    _expiryLabel = nil;
  }
  
  float combinedHeight = currentY;
  float padding = (_backingCard.frame.size.height - _infoArea.frame.size.height) - combinedHeight;
  float topPadding = padding/2;
  
  currentY = topPadding;
  [_titleLabel setFrame:CGRectMake(labelX, currentY, _titleLabel.frame.size.width, _titleLabel.frame.size.height)];
  currentY += _titleLabel.frame.size.height + innerSpacing;
  if (rules.length > 0) {
    [_infoLabel setFrame:CGRectMake(labelX, currentY, _infoLabel.frame.size.width, _infoLabel.frame.size.height)];
    currentY += _infoLabel.frame.size.height + innerSpacing;
  }
  if (info != nil) {
    [_expiryLabel setFrame:CGRectMake(labelX, currentY, _expiryLabel.frame.size.width, _expiryLabel.frame.size.height)];
  }
  
  
  CALayer *topBorder = [CALayer layer];
  topBorder.frame = CGRectMake(0.0f, 0.0f, _backingCard.frame.size.width, 0.5f);
  topBorder.backgroundColor = [UIColor grayColor].CGColor;
  [_infoArea.layer addSublayer:topBorder];
  
  NSString *action = [self infoStringForReward:reward];
  NSMutableAttributedString *actionString = [[NSMutableAttributedString alloc]
                                           initWithString:action attributes:@{
                                                                            NSFontAttributeName : PopdeemFont(PDThemeFontLight, 12),
                                                                            NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryApp)
                                                                            }];
  [_actionLabel setAttributedText:actionString];

  if (reward.action != PDRewardActionNone) {
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
        [_socialIconOne setImage:PopdeemImage(@"pduirewardinstagramicon")];
        [_socialIconOne setHidden:NO];
      }
      if ([reward.socialMediaTypes[1] isEqualToNumber:@(PDSocialMediaTypeFacebook)]) {
        [_socialIconTwo setImage:PopdeemImage(@"pduirewardfacebookicon")];
        [_socialIconTwo setHidden:NO];
      } else if ([reward.socialMediaTypes[1] isEqualToNumber:@(PDSocialMediaTypeTwitter)]) {
        [_socialIconTwo setImage:PopdeemImage(@"pduirewardtwittericon")];
        [_socialIconTwo setHidden:NO];
      } else if ([reward.socialMediaTypes[1] isEqualToNumber:@(PDSocialMediaTypeInstagram)]) {
        [_socialIconTwo setImage:PopdeemImage(@"pduirewardinstagramicon")];
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
        [_socialIconOne setImage:PopdeemImage(@"pduirewardinstagramicon")];
        [_socialIconOne setHidden:NO];
      }
    }
  } else {
    [_socialIconOne setHidden:YES];
    [_socialIconTwo setHidden:YES];
    [_socialIconThree setHidden:YES];
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
          break;
        case PDRewardActionSocialLogin:
          action = translationForKey(@"popdeem.claim.action.socialLogin", @"Social Login");
          break;
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
          action = translationForKey(@"popdeem.claim.action.photo", @"📸 Photo Required");
          break;
        case PDRewardActionNone:
          action = translationForKey(@"popdeem.claim.action.noAction", @"No Action Required");
          break;
        case PDRewardActionSocialLogin:
          action = translationForKey(@"popdeem.claim.action.socialLogin", @"Social Login");
          break;
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
          action = translationForKey(@"popdeem.claim.action.photo", @"📸 Photo Required");
          break;
        case PDRewardActionNone:
          action = translationForKey(@"popdeem.claim.action.noAction", @"No Action Required");
          break;
        case PDRewardActionSocialLogin:
          action = translationForKey(@"popdeem.claim.action.socialLogin", @"Social Login");
          break;
        default:
          action = translationForKey(@"popdeem.claim.action.noAction", @"No Action Required");
          break;
      }
    } else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeInstagram)]) {
      //Twitter Only
      action = translationForKey(@"popdeem.claim.action.photo", @"📸 Photo Required");
      
    }
  } else if (types.count == 0) {
    switch (reward.action) {
      case PDRewardActionCheckin:
        action = translationForKey(@"popdeem.claim.action.checkin", @"Check-in Required");
        break;
      case PDRewardActionPhoto:
        action = translationForKey(@"popdeem.claim.action.photo", @"📸 Photo Required");
        break;
      case PDRewardActionNone:
        action = translationForKey(@"popdeem.claim.action.noAction", @"No Action Required");
        break;
      case PDRewardActionSocialLogin:
        action = translationForKey(@"popdeem.claim.action.socialLogin", @"Social Login");
        break;
      default:
        action = translationForKey(@"popdeem.claim.action.noAction", @"No Action Required");
        break;
    }
  }
  
  return [NSString stringWithFormat:@"%@",action];
  
}

- (NSString *) expiryStringForReward:(PDReward*)reward {
  
  if (reward.unlimitedAvailability) {
    return nil;
  }
  
  NSString *exp = nil;
  if (reward.unlimitedAvailability == NO) {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:[NSDate date]
                                                          toDate:[NSDate dateWithTimeIntervalSince1970:reward.availableUntil]
                                                         options:0];
    
    NSDateComponents *untilComponents = [gregorianCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSince1970:reward.availableUntil]];
    

    NSTimeInterval interval = [[NSDate dateWithTimeIntervalSince1970:reward.availableUntil] timeIntervalSinceDate:[NSDate date]];
    int intervalHours = interval/60/60;
    int intervalDays = interval/60/60/24;
    int intervalWeeks = interval/60/60/24/7;
    int intervalMonths = interval/60/60/24/7;
    
    if (intervalMonths >= 1) {
      return nil;
    }
    if (intervalWeeks > 3) {
      return nil;
    }
    
    if (intervalMonths > 0) {
      if (intervalMonths > 1) {
        exp = [NSString stringWithFormat:@"%li months left to claim",(long)intervalMonths];
      } else {
       exp = [NSString stringWithFormat:@"%li month left to claim",(long)intervalMonths];
      }
    } else if (intervalDays > 6) {
      exp = [NSString stringWithFormat:@"%li weeks left to claim",(long)intervalWeeks];
    } else if (intervalDays < 7 && intervalHours > 24) {
      exp = [NSString stringWithFormat:@"%li days left to claim",(long)intervalDays];
    } else {
      exp = [NSString stringWithFormat:@"%li hours left to claim",(long)intervalHours];
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
