//
//  PDUISocialClaimTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/05/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDUISocialClaimTableViewCell.h"
#import "PDUIClaimV2ViewController.h"
#import "PDUtils.h"
#import "PDTheme.h"
#import "PDSocialMediaManager.h"

@interface PDUISocialClaimTableViewCell()
@property (nonatomic) BOOL working;
@end

@implementation PDUISocialClaimTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.socialLabel setFont:PopdeemFont(PDThemeFontPrimary, 16)];
    [self.socialSwitch setOn:NO];
    [self setBackgroundColor:[UIColor whiteColor]];
    // Initialization code
}

- (void) setEnabled:(BOOL)enabled {
    if (!enabled) {
        switch (self.socialMediaType) {
            case PDSocialMediaTypeFacebook:
                [self.socialImageView setImage:PopdeemImage(@"pduikit_fbbutton_deselected")];
                break;
            case PDSocialMediaTypeTwitter:
                [self.socialImageView setImage:PopdeemImage(@"pduikit_twitterbutton_deselected")];
                break;
            case PDSocialMediaTypeInstagram:
                [self.socialImageView setImage:PopdeemImage(@"pduikit_instagrambutton_deselected")];
                break;
            default:
                break;
        }
        [self.socialSwitch setEnabled:NO];
        [self setUserInteractionEnabled:NO];
    } else {
        switch (self.socialMediaType) {
            case PDSocialMediaTypeFacebook:
                [self.socialImageView setImage:PopdeemImage(@"pduikit_fbbutton_selected")];
                break;
            case PDSocialMediaTypeTwitter:
                [self.socialImageView setImage:PopdeemImage(@"pduikit_twitterbutton_selected")];
                break;
            case PDSocialMediaTypeInstagram:
                [self.socialImageView setImage:PopdeemImage(@"pduikit_instagrambutton_selected")];
                break;
            default:
                break;
        }
        [self.socialSwitch setEnabled:YES];
        [self setUserInteractionEnabled:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) setSocialNetwork:(PDSocialMediaType)mediaType {
    self.socialMediaType = mediaType;
    switch (mediaType) {
        case PDSocialMediaTypeFacebook:
            self.socialLabel.text = @"Facebook";
            [self.socialImageView setImage:PopdeemImage(@"pduikit_fbbutton_selected")];
            break;
        case PDSocialMediaTypeTwitter:
            self.socialLabel.text = @"Twitter";
            [self.socialImageView setImage:PopdeemImage(@"pduikit_twitterbutton_selected")];
            break;
        case PDSocialMediaTypeInstagram:
            self.socialLabel.text = @"Instagram";
            [self.socialImageView setImage:PopdeemImage(@"pduikit_instagrambutton_selected")];
            break;
        default:
            break;
    }
}



- (IBAction)switchToggled:(UISwitch*)sender {
    //Functionality for switch toggle
    switch (self.socialMediaType) {
        case PDSocialMediaTypeFacebook:
            [_parent facebookToggled:sender.isOn];
            break;
        case PDSocialMediaTypeTwitter:
            [_parent twitterToggled:sender.isOn];
            break;
        case PDSocialMediaTypeInstagram:
            [_parent instagramToggled:sender.isOn];
            break;
        default:
            break;
    }
}

- (void) startAnimatingSpinner {}
- (void) stopAnimatingSpinner {}


@end
