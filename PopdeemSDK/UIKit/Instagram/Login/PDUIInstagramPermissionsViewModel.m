//
//  PDUIInstagramPermissionsViewModel.m
//  PopdeemSDK
//
//  Created by Popdeem on 24/01/2020.
//


#import "PDUIInstagramPermissionsViewModel.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDUIInstagramPermissionsViewController.h"

@implementation PDUIInstagramPermissionsViewModel

- (instancetype) initWithController:(PDUIInstagramPermissionsViewController*)controller {
    if (self = [super init]) {
        self.controller = controller;
        [self setup];
        return self;
    }
    return nil;
}

- (void) setup {
    
    self.viewOneLabelOneText = [NSString stringWithFormat:translationForKey(@"popdeem.instagram.share.stepOne.label1", @"Instagram Permissions")];
    
    self.viewOneLabelTwoText = [NSString stringWithFormat:translationForKey(@"popdeem.instagram.share.stepOne.label1", @"Please ensure you give the following permissions to avail of Social Rewards")];

    self.viewOneActionButtonText = translationForKey(@"popdeem.instagram.share.stepOne.buttonText", @"Okay, Gotcha");
    
    self.viewOneLabelOneFont = PopdeemFont(PDThemeFontBold, 18);
    self.viewOneLabelOneColor = PopdeemColor(PDThemeColorPrimaryFont);
    
    self.viewOneLabelTwoFont = PopdeemFont(PDThemeFontPrimary, 15);
    self.viewOneLabelTwoColor = PopdeemColor(PDThemeColorPrimaryFont);
    
     self.viewOneActionButtonFont = PopdeemFont(PDThemeFontBold, 15);

    NSString *buttonColor;
    
    if (PopdeemThemeHasValueForKey(PDThemeColorButtons)) {
        buttonColor = PopdeemColor(PDThemeColorButtons);
    } else {
        buttonColor = PopdeemColor(PDThemeColorPrimaryApp);
    }
    
    self.viewOneActionButtonColor = buttonColor;
    self.viewOneActionButtonBorderColor = buttonColor;
    self.viewOneActionButtonTextColor= [UIColor whiteColor];

    self.viewOneImage = PopdeemImage(@"pduikit_instagram_permissions");

}
@end

