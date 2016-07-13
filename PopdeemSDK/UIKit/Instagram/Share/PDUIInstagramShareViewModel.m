//
//  PDUIInstagramShareViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIInstagramShareViewModel.h"
#import "PDTheme.h"
#import "PDUtils.h"

@implementation PDUIInstagramShareViewModel

- (instancetype) init {
	if (self = [super init]) {
		[self setup];
		return self;
	}
	return nil;
}

- (void) setup {
	self.viewOneLabelOneText = translationForKey(@"popdeem.instagram.share.stepOne.label1", @"Your message has been copied to the clipboard.");
	self.viewOneLabelTwoText = translationForKey(@"popdeem.instagram.share.stepOne.label2", @"You will now be directed to Instagram where you can paste the message. Tap and hold to paste your message.");
	self.viewOneActionButtonText = translationForKey(@"popdeem.instagram.share.stepOne.buttonText", @"Next");
	
	self.viewTwoLabelOneText = translationForKey(@"popdeem.instagram.share.stepTwo.label1", @"Make sure you are logged into the correct account on Instagram.");
	self.viewTwoLabelTwoText = translationForKey(@"popdeem.instagram.share.stepTwo.label2", @"Your post will publish to whichever account you are currently logged into on the Instagram app.");
	self.viewTwoActionButtonText = translationForKey(@"popdeem.instagram.share.stepTwo.buttonText", @"Okay, Gotcha");
	
	self.viewOneLabelOneFont = PopdeemFont(@"popdeem.fonts.boldFont", 14);
	self.viewOneLabelTwoFont = PopdeemFont(@"popdeem.fonts.primaryFont", 14);
	self.viewTwoLabelOneFont = PopdeemFont(@"popdeem.fonts.boldFont", 14);
	self.viewTwoLabelTwoFont = PopdeemFont(@"popdeem.fonts.primaryFont", 14);
	self.viewOneActionButtonFont = PopdeemFont(@"popdeem.fonts.boldFont", 14);
	self.viewTwoActionButtonFont = PopdeemFont(@"popdeem.fonts.boldFont", 14);
	
	self.viewOneLabelOneColor = PopdeemColor(@"popdeem.colors.primaryFontColor");
	self.viewOneLabelTwoColor = PopdeemColor(@"popdeem.colors.primaryFontColor");
	self.viewTwoLabelOneColor = PopdeemColor(@"popdeem.colors.primaryFontColor");
	self.viewTwoLabelTwoColor = PopdeemColor(@"popdeem.colors.primaryFontColor");

	self.viewOneActionButtonColor = [UIColor whiteColor];
	self.viewOneActionButtonBorderColor = PopdeemColor(@"popdeem.colors.primaryAppColor");
	self.viewTwoActionButtonColor = PopdeemColor(@"popdeem.colors.primaryAppColor");
	self.viewOneActionButtonTextColor= PopdeemColor(@"popdeem.colors.primaryAppColor");
	self.viewTwoActionButtonTextColor= PopdeemColor(@"popdeem.colors.primaryInverseColor");
	
	self.viewOneImage = PopdeemImage(@"pduikit_instagramstep1");
	self.viewTwoImage = PopdeemImage(@"pduikit_instagramstep2");
}

@end
