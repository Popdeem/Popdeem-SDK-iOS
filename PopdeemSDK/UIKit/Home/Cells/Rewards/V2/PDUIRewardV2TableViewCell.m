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
  
  float sideIndent = 20;
  float topIndent = 10;
  _backingCard = [[UIView alloc] initWithFrame:CGRectMake(sideIndent, topIndent, self.frame.size.width - 2*sideIndent, self.frame.size.height - 2* topIndent)];
  _backingCard.layer.cornerRadius = 5.0;
  _backingCard.clipsToBounds = YES;
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_backingCard.bounds];
  _backingCard.layer.masksToBounds = NO;
  _backingCard.layer.shadowColor = [UIColor blackColor].CGColor;
  _backingCard.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
  _backingCard.layer.shadowOpacity = 0.5f;
  _backingCard.layer.shadowPath = shadowPath.CGPath;
  [self addSubview: _backingCard];
  
//  if (reward.coverImageUrl) {
//    if ([reward.coverImageUrl rangeOfString:@"reward_default"].location != NSNotFound) {
//      [self.rewardImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
//    } else if (reward.coverImage) {
//      [self.rewardImageView setImage:reward.coverImage];
//    } else {
//      [self.rewardImageView setImage:nil];
//    }
//  } else {
//    [self.rewardImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
//  }
  
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
