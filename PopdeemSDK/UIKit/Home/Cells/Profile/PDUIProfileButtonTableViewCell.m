//
//  PDUIProfileButtonTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/01/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDUIProfileButtonTableViewCell.h"
#import "PDUtils.h"
#import "PDTheme.h"

@implementation PDUIProfileButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  [self.label setFont:PopdeemFont(PDThemeFontPrimary, 16)];
  [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
