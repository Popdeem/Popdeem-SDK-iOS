//
//  PDUIInstagramLoginViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIInstagramLoginViewModel.h"
#import "PDUIInstagramLoginViewController.h"
#import "PDUtils.h"
#import "PDTheme.h"

@implementation PDUIInstagramLoginViewModel

- (instancetype) initForParent:(UIViewController*)parent {
	if (self = [super init]) {
		return self;
	}
	return nil;
}

- (void) setup {
	self.labelText = translationForKey(@"popdeem.instagram.connect.labelText",@"You must connect your Instagram account to claim this reward.");
	self.labelColor = PopdeemColor(PDThemeColorPrimaryFont);
	self.labelFont = PopdeemFont(PDThemeFontBold, 14);
	
	self.logoImage = PopdeemImage(@"pduikit_instagram_hires");
	
	self.buttonColor = PopdeemColor(PDThemeColorPrimaryApp);
	self.buttonTextColor = PopdeemColor(PDThemeColorPrimaryInverse);
	self.buttonLabelFont = PopdeemFont(PDThemeFontBold, 16);
	self.buttonText = translationForKey(@"popdeem.instagram.connect.actionButtonTitle", @"Continue");
}

@end
