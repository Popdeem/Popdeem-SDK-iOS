//
//  PDUISocialSettingsTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUISocialSettingsTableViewCell.h"
#import "PDUtils.h"
#import "PDTheme.h"
#import "PDSocialMediaManager.h"

@interface PDUISocialSettingsTableViewCell()
  @property (nonatomic) PDSocialMediaType socialMediaType;
  @property (nonatomic) BOOL working;
@end
@implementation PDUISocialSettingsTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[self.socialSwitch setOn:NO];
    // Initialization code
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
	[self checkLogin];
}

- (void) checkLogin {
	switch (self.socialMediaType) {
  case PDSocialMediaTypeFacebook:
			[self checkFacebook];
			break;
	
	case PDSocialMediaTypeTwitter:
			[self checkTwitter];
			break;
	
	case PDSocialMediaTypeInstagram:
			[self checkInstagram];
		break;
  default:
			break;
	}
}

- (void) checkFacebook {
	PDSocialMediaManager *man = [PDSocialMediaManager manager];
	if ([man isLoggedInWithFacebook] && [[[PDUser sharedInstance] facebookParams] accessToken] != nil && [[[PDUser sharedInstance] facebookParams] accessToken].length > 0) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.socialSwitch setOn:YES animated:YES];
			[self setNeedsDisplay];
		});
	} else {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.socialSwitch setOn:NO animated:YES];
			[self setNeedsDisplay];
		});
	}
}

- (void) checkTwitter {
	PDSocialMediaManager *man = [PDSocialMediaManager manager];
	BOOL connected = [man isLoggedInWithTwitter];
	[self.socialSwitch setOn:connected animated:YES];
	[self setNeedsDisplay];
}

- (void) checkInstagram {
  //Just a dirty way to determine if a user is "logged in" with instagram. We verify the token later.
  if ([[[[PDUser sharedInstance] instagramParams] accessToken] length] > 0) {
    [self.socialSwitch setOn:YES animated:YES];
    [self setNeedsDisplay];
  } else {
    [self.socialSwitch setOn:NO animated:YES];
    [self setNeedsDisplay];
  }
  
  //Verify the token for real. This takes a moment - above is to avoid the text on the button changing before the users eyes.
	PDSocialMediaManager *man = [PDSocialMediaManager manager];
	[man isLoggedInWithInstagram:^(BOOL isLoggedIn){
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.socialSwitch setOn:isLoggedIn animated:YES];
			[self setNeedsDisplay];
		});
	}];
}

- (IBAction)switchToggled:(UISwitch*)sender {
	//Functionality for switch toggle
	if (sender.isOn) {
		switch (self.socialMediaType) {
			case PDSocialMediaTypeFacebook:
				[_parent connectFacebookAccount];
				break;
			case PDSocialMediaTypeTwitter:
				[_parent connectTwitterAccount];
				break;
			case PDSocialMediaTypeInstagram:
				[_parent connectInstagramAccount];
				break;
			default:
    break;
		}
	} else {
		switch (self.socialMediaType) {
			case PDSocialMediaTypeFacebook:
				[_parent disconnectFacebookAccount];
				break;
			case PDSocialMediaTypeTwitter:
				[_parent disconnectTwitterAccount];
				break;
			case PDSocialMediaTypeInstagram:
				[_parent disconnectInstagramAccount];
				break;
			default:
    break;
		}
	}	
}

- (void) startAnimatingSpinner {}
- (void) stopAnimatingSpinner {}


@end
