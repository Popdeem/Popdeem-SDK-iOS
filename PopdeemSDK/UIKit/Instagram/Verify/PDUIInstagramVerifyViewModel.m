//
//  PDUIInstagramVerifyViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 23/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIInstagramVerifyViewModel.h"
#import "PDTheme.h"
#import "PDUtils.h"

@implementation PDUIInstagramVerifyViewModel

- (instancetype) initForViewController:(UIViewController*)viewController {
	if (self = [super init]){
		_viewController = viewController;
	}
}

- (void) setup {
	_headerColor = PopdeemColor(@"popdeem.colors.primaryAppColor");
	_headerFontColor = PopdeemColor(@"popdeem.colors.primaryInverseColor");
	_headerFont = PopdeemFont(@"popdeem.fonts.primaryFont", 17);
	
	_messageFontColor = PopdeemColor(@"popdeem.colors.primaryFontColor");
	_messageFont = PopdeemFont(@"popdeem.fonts.primaryFont", 14);
	
	_buttonColor = PopdeemColor(@"popdeem.colors.primaryInverseColor");
	_buttonFontColor = PopdeemColor(@"popdeem.colors.primaryAppColor");
	_headerFont = PopdeemFont(@"popdeem.fonts.boldFont", 17);
	
	_headerText = translationForKey(@"popdeem.instagram.verify.headerText",@"Verify");
	
	
}

@end
