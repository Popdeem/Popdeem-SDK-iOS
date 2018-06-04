//
//  PDUIScanNowTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/05/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDUIScanNowTableViewCell.h"
#import "PDUtils.h"
#import "PDTheme.h"
#import "PDReward.h"

@implementation PDUIScanNowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.label setText:translationForKey(@"popdeem.claim.scanNow.title", @"Scan for already shared activity")];
    [self.label setFont:PopdeemFont(PDThemeFontPrimary, 16)];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void) setReward:(PDReward *)reward {
  if (reward.action == PDRewardActionPhoto) {
     [self.label setText:translationForKey(@"popdeem.claim.scanNow.title.photo", @"Scan for already shared photo")];
  } else {
     [self.label setText:translationForKey(@"popdeem.claim.scanNow.title.checkin", @"Scan for already shared activity")];
  }
  [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
