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
    [self.label setHidden:NO];
    [self.iconView setHidden:NO];
    
    [self.changePhotoLabel setText:translationForKey(@"popdeem.claim.changePhoto.title", @"Change Photo")];
    [self.changePhotoLabel setFont:PopdeemFont(PDThemeFontPrimary, 16)];
    [self.changePhotoLabel setHidden:YES];
    [self.addedPhotoImageView setHidden:YES];
    // Initialization code
}

- (void) setPhoto:(UIImage*)photo {
    if (photo == nil) {
        [_addedPhotoImageView setHidden:YES];
        [_changePhotoLabel setHidden:YES];
        [_iconView setHidden:NO];
        [_label setHidden:NO];
    } else {
        [_addedPhotoImageView setImage:photo];
        [_addedPhotoImageView setHidden:NO];
        [_addedPhotoImageView setClipsToBounds:YES];
        [_addedPhotoImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_addedPhotoImageView setBackgroundColor:[UIColor blackColor]];
        [_changePhotoLabel setHidden:NO];
        [_iconView setHidden:YES];
        [_label setHidden:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
