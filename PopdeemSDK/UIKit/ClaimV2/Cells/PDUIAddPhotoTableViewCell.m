//
//  PDUIAddPhotoTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/05/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDUIAddPhotoTableViewCell.h"
#import "PDUtils.h"
#import "PDTheme.h"


@implementation PDUIAddPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.label setText:translationForKey(@"popdeem.claim.addPhoto.title", @"Add Photo")];
    [self.label setFont:PopdeemFont(PDThemeFontPrimary, 16)];
    self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor whiteColor]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
