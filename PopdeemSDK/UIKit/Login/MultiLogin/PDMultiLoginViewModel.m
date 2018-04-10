//
//  PDMultiLoginViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/01/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import "PDMultiLoginViewModel.h"
#import "PDTheme.h"
#import "PDConstants.h"
#import "PDUtils.h"

@implementation PDMultiLoginViewModel

- (instancetype) initForViewController:(PDMultiLoginViewController*)controller {
	if (self = [super init]) {
		return self;
	}
	return nil;
}

- (void) setup {
  _image = PopdeemImage(@"popdeem.images.loginImage");
	_twitterButtonColor = [UIColor colorWithRed:0.33 green:0.67 blue:0.93 alpha:1.0];
	_instagramButtonColor = [UIColor colorWithRed:1.00 green:0.24 blue:0.17 alpha:1.00];
  
	_twitterButtonFont = PopdeemFont(PDThemeFontPrimary, 15.0);
  _instagramButtonFont = PopdeemFont(PDThemeFontPrimary, 15.0);
  _facebookButtonFont = PopdeemFont(PDThemeFontPrimary, 15.0);
  
	_twitterButtonText = translationForKey(@"popdeem.sociallogin.twitterButtonText", @"Log in with Twitter");
  _instagramButtonText = translationForKey(@"popdeem.sociallogin.instagramButtonText", @"Log in with Instagram");
  _facebookButtonText = translationForKey(@"popdeem.sociallogin.facebookButtonText", @"Log in with Facebook");
	
	_titleColor = PopdeemColor(PDThemeColorPrimaryFont);
	_titleFont = PopdeemFont(PDThemeFontBold, 18.0);
	_titleString = translationForKey(@"popdeem.sociallogin.tagline", @"New: Social Rewards");
	
	_bodyColor = PopdeemColor(PDThemeColorPrimaryFont);
	_bodyFont = PopdeemFont(PDThemeFontPrimary, 14.0);
	_bodyString = translationForKey(@"popdeem.sociallogin.body", @"Connect your Social account to turn social features on. This will give you access to exclusive content and new social rewards.");
	
}

@end
