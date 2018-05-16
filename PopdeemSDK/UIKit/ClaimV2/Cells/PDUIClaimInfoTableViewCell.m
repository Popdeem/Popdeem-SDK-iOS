//
//  PDUIClaimInfoTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/05/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDUIClaimInfoTableViewCell.h"
#import "PDUtils.h"
#import "PDTheme.h"

@implementation PDUIClaimInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.infoLabel setFont:PopdeemFont(PDThemeFontPrimary, 12)];
    [self.infoLabel setNumberOfLines:2];
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGFLOAT_MAX);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
