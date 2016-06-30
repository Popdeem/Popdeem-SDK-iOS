//
//  PDUICardViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 17/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUICardViewModel.h"
#import "PDTheme.h"

@implementation PDUICardViewModel

- (instancetype) initWithController:(PDUICardViewController*)controller
												 headerText:(NSString*)headerText
													 bodyText:(NSString*)bodyText
													image:(UIImage*)image
									actionButtonTitle:(NSString*)actionButtonTitle
									otherButtonTitles:(NSArray*)otherButtonTitles {
	if (self = [super init]) {
		_controller = controller;
		_headerText = headerText;
		_bodyText = bodyText;
		_image = image;
		_actionButtonTitle = actionButtonTitle;
		_otherButtonTitles = otherButtonTitles;
		
		_headerColor = PopdeemColor(@"popdeem.colors.primaryAppColor");
		_headerLabelColor = PopdeemColor(@"popdeem.colors.primaryInverseColor");
		_bodyLabelColor = PopdeemColor(@"popdeem.colors.primaryFontColor");
		_actionButtonColor = PopdeemColor(@"popdeem.colors.primaryAppColor");
		_actionButtonLabelColor = PopdeemColor(@"popdeem.colors.primaryInverseColor");
		_otherButtonsColor = [UIColor whiteColor];
		_otherButtonsLabelColor = PopdeemColor(@"popdeem.colors.primaryFontColor");
		
		_headerFont = PopdeemFont(@"popdeem.fonts.boldFont", 17);
		_bodyFont = PopdeemFont(@"popdeem.fonts.primaryFont", 14);
		_actionButtonFont = PopdeemFont(@"popdeem.fonts.primaryFont", 14);
		_otherButtonsFont = PopdeemFont(@"popdeem.fonts.primaryFont", 14);
		return self;
	}
	return nil;
}

@end
