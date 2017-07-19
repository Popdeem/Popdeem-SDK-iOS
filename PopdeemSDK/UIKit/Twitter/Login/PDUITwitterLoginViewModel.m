//
//  PDUITwitterLoginViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUITwitterLoginViewModel.h"
#import "PDTheme.h"
#import "PDUtils.h"

@implementation PDUITwitterLoginViewModel

- (instancetype) initForParent:(UIViewController*)parent {
	if (self = [super init]) {
		
		return self;
	}
	return nil;
}

- (void) setIsLoading:(BOOL)loading {
	if (loading) {
		[self setupLoading];
	} else {
		[self setup];
	}
}

- (void) setup {
	self.labelText = translationForKey(@"popdeem.twitter.connect.read.labelText", @"Connect your Twitter account to claim Twitter Rewards.");
	self.labelColor = PopdeemColor(PDThemeColorPrimaryFont);
	self.labelFont = PopdeemFont(PDThemeFontBold, 14);
	
	self.logoImage = PopdeemImage(@"Twitter_Logo_Blue");
	
	self.buttonColor = PopdeemColor(PDThemeColorPrimaryApp);
	self.buttonTextColor = PopdeemColor(PDThemeColorPrimaryInverse);
	self.buttonLabelFont = PopdeemFont(PDThemeFontBold, 16);
	self.buttonText = translationForKey(@"popdeem.twitter.connect.read.actionButtonTitle", @"Continue");
}

- (void) setupLoading {
	self.labelText = translationForKey(@"popdeem.twitter.loading.labelText",@"Connecting Twitter Account.");
	self.labelColor = PopdeemColor(PDThemeColorPrimaryFont);
	self.labelFont = PopdeemFont(PDThemeFontBold, 14);
	
	self.logoImage = PopdeemImage(@"Twitter_Logo_Blue");
	
	self.buttonColor = PopdeemColor(PDThemeColorPrimaryInverse);
	self.buttonTextColor = PopdeemColor(PDThemeColorPrimaryApp);
	self.buttonLabelFont = PopdeemFont(PDThemeFontBold, 16);
	self.buttonText = translationForKey(@"popdeem.twitter.loading.actionButtonTitle", @"Connecting...");
	self.buttonBorderColor = PopdeemColor(PDThemeColorPrimaryApp);
}

@end
