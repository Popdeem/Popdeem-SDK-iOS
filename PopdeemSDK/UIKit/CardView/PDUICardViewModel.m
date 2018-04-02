//
//  PDUICardViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 17/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUICardViewModel.h"
#import "PDTheme.h"
#import "PDConstants.h"

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
		
		_headerColor = PopdeemColor(PDThemeColorPrimaryApp);
		_headerLabelColor = PopdeemColor(PDThemeColorPrimaryInverse);
		_bodyLabelColor = PopdeemColor(PDThemeColorPrimaryFont);
		_actionButtonColor = PopdeemColor(PDThemeColorPrimaryApp);
		_actionButtonLabelColor = PopdeemColor(PDThemeColorPrimaryInverse);
		_otherButtonsColor = [UIColor whiteColor];
		_otherButtonsLabelColor = PopdeemColor(PDThemeColorPrimaryFont);
		
		_headerFont = PopdeemFont(PDThemeFontBold, 17);
		_bodyFont = PopdeemFont(PDThemeFontPrimary, 14);
		_actionButtonFont = PopdeemFont(PDThemeFontPrimary, 14);
		_otherButtonsFont = PopdeemFont(PDThemeFontPrimary, 14);
		return self;
	}
	return nil;
}

@end
