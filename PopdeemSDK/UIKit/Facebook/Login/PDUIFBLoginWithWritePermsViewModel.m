//
//  PDUIFBLoginWithWritePermsViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 26/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIFBLoginWithWritePermsViewModel.h"
#import "PDUtils.h"
#import "PDTheme.h"

@implementation PDUIFBLoginWithWritePermsViewModel

- (instancetype) initForParent:(UIViewController*)parent {
	if (self = [super init]) {
		return self;
	}
	return nil;
}

- (void) setup {
	self.labelText = translationForKey(@"popdeem.facebook.connect.labelText",@"You must grant Publish Permissions to claim this reward. We will never post to Facebook without your explicit permission.");
	self.labelColor = PopdeemColor(PDThemeColorPrimaryFont);
	self.labelFont = PopdeemFont(PDThemeFontPrimary, 14);
	
	self.logoImage = PopdeemImage(@"pduikit_facebook_hires");
	
	self.buttonColor = PopdeemColor(PDThemeColorPrimaryApp);
	self.buttonTextColor = PopdeemColor(PDThemeColorPrimaryInverse);
	self.buttonLabelFont = PopdeemFont(PDThemeFontBold, 16);
	self.buttonText = translationForKey(@"popdeem.facebook.connect.actionButtonTitle", @"Continue");
}


@end
