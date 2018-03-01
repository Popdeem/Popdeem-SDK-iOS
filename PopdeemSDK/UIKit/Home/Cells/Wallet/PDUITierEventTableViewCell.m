//
//  PDUITierEventTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 01/03/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDUITierEventTableViewCell.h"
#import "PDTheme.h"
#import "PDUtils.h"

@interface PDUITierEventTableViewCell()
@property (nonatomic, retain) UIColor *primaryAppColor;
@property (nonatomic, retain) UIColor *primaryFontColor;
@property (nonatomic, retain) UIColor *secondaryFontColor;
@end

@implementation PDUITierEventTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.separatorInset = UIEdgeInsetsZero;
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  [self setBackgroundColor:[UIColor clearColor]];
  if (PopdeemThemeHasValueForKey(PDThemeColorTableViewCellBackground)) {
    [self setBackgroundColor:PopdeemColor(PDThemeColorTableViewCellBackground)];
    self.contentView.backgroundColor = PopdeemColor(PDThemeColorTableViewCellBackground);
  }
}

- (void) setupForTierEvent:(PDTierEvent*)event {
  
  NSString *emoji = @"";
  switch (event.toTier) {
    case 0:
      emoji = translationForKey(@"popdeem.tiers.level0Emoji", @"🏅");
      break;
    case 1:
      emoji = translationForKey(@"popdeem.tiers.level1Emoji", @"🥉");
      break;
    case 2:
      emoji = translationForKey(@"popdeem.tiers.level2Emoji", @"🥈");
      break;
    case 3:
      emoji = translationForKey(@"popdeem.tiers.level3Emoji", @"🥇");;
      break;
    default:
      emoji = translationForKey(@"popdeem.tiers.level0Emoji", @"🏅");
      break;
  }
  
  _primaryAppColor = PopdeemColor(PDThemeColorPrimaryApp);
  _primaryFontColor = PopdeemColor(PDThemeColorPrimaryFont);
  _secondaryFontColor = PopdeemColor(PDThemeColorSecondaryFont);
  
  [_emojiLabel setText:emoji];
  [_mainLabel setTextColor:_primaryFontColor];
  
  NSMutableAttributedString *labelAttString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{}];
  
  NSMutableAttributedString *topString = [[NSMutableAttributedString alloc]
                                                  initWithString:[self topStringForEvent:event]
                                                  attributes:@{
                                                               NSFontAttributeName : PopdeemFont(PDThemeFontBold, 14),
                                                               NSForegroundColorAttributeName : _primaryFontColor
                                                               }];
  
  [labelAttString appendAttributedString:topString];
  
  float labelx = _emojiLabel.frame.size.width + 16;
  float labelWidth = self.frame.size.width - labelx - 24;
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
                                           initWithString:translationForKey(@"popdeem.tiers.bottomLabelString", @"Share your experience to increase your status and unlock new rewards")
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
  
}

- (NSString*) topStringForEvent:(PDTierEvent*)event {
  NSString *level1Name = translationForKey(@"popdeem.tiers.tier1Name", @"Bronze");
  NSString *level2Name = translationForKey(@"popdeem.tiers.tier2Name", @"Silver");
  NSString *level3Name = translationForKey(@"popdeem.tiers.tier3Name", @"Gold");
  if (event.fromTier < event.toTier) {
    switch (event.toTier) {
        case 1:
        return [NSString stringWithFormat:translationForKey(@"popdeem.tiers.levelUp", @"Congratulations, you earned %@ ambassador status"), level1Name];
        break;
      case 2:
        return [NSString stringWithFormat:translationForKey(@"popdeem.tiers.levelUp", @"Congratulations, you earned %@ ambassador status"), level2Name];
        break;
      case 3:
        return [NSString stringWithFormat:translationForKey(@"popdeem.tiers.levelUp", @"Congratulations, you earned %@ ambassador status"), level3Name];
        break;
      default:
        return [NSString stringWithFormat:translationForKey(@"popdeem.tiers.levelUp", @"Congratulations, you earned %@ ambassador status"), level1Name];
        break;
    }
  } else {
    switch (event.toTier) {
      case 1:
        return [NSString stringWithFormat:translationForKey(@"popdeem.tiers.levelDown", @"You are now a %@ ambassador"), level1Name];
        break;
      case 2:
        return [NSString stringWithFormat:translationForKey(@"popdeem.tiers.levelDown", @"You are now a %@ ambassador"), level2Name];
        break;
      default:
        return [NSString stringWithFormat:translationForKey(@"popdeem.tiers.levelDown", @"You are now a %@ ambassador"), level1Name];
        break;
    }
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
