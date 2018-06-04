//
//  PDUIFacebookShareViewModel.m
//  Bolts
//
//  Created by Niall Quinn on 22/05/2018.
//

#import "PDUIFacebookShareViewModel.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDCustomer.h"
#import "PDUIFacebookShareViewController.h"

@implementation PDUIFacebookShareViewModel

- (instancetype) initWithController:(PDUIFacebookShareViewController*)controller {
  if (self = [super init]) {
    self.controller = controller;
    [self setup];
    return self;
  }
  return nil;
}

- (void) setup {
  
  
  if (_controller.image) {
    self.viewOneLabelOneText = translationForKey(@"popdeem.facebook.share.stepOne.label1.image", @"Share your photo");
  } else {
    self.viewOneLabelOneText = translationForKey(@"popdeem.facebook.share.stepOne.label1.checkin", @"Check-in");
  }
  
  if (_controller.parent.reward.forcedTag) {
     self.viewOneLabelTwoText = [NSString stringWithFormat:translationForKey(@"popdeem.facebook.share.stepOne.label2", @"Your post must include the hashtag %@, or you will be unable to claim your reward."), _controller.parent.reward.forcedTag];
  } else {
    self.viewOneLabelTwoText = translationForKey(@"popdeem.facebook.share.stepOne.label2", @"Your post must include the specified hashtag, or you will be unable to claim your reward.");
  }
                              
  self.viewOneActionButtonText = translationForKey(@"popdeem.facebook.share.stepOne.buttonText", @"Next");
  
  self.viewTwoLabelOneText = translationForKey(@"popdeem.facebook.share.stepTwo.label1", @"Step Two Label 1");
  self.viewTwoLabelTwoText = translationForKey(@"popdeem.facebook.share.stepTwo.label2", @"Step Two Label 2");
  self.viewTwoActionButtonText = translationForKey(@"popdeem.facebook.share.stepTwo.buttonText", @"Next");
  
  self.viewThreeLabelOneText = translationForKey(@"popdeem.facebook.share.stepThree.label1", @"Step 3 Label 1");
  self.viewThreeLabelTwoText = translationForKey(@"popdeem.facebook.share.stepThree.label2", @"Step 3 Label 2");
  self.viewThreeActionButtonText = translationForKey(@"popdeem.facebook.share.stepThree.buttonText", @"Okay, Gotcha");
  
  self.viewOneLabelOneFont = PopdeemFont(PDThemeFontBold, 14);
  self.viewOneLabelTwoFont = PopdeemFont(PDThemeFontPrimary, 14);
  self.viewTwoLabelOneFont = PopdeemFont(PDThemeFontBold, 14);
  self.viewTwoLabelTwoFont = PopdeemFont(PDThemeFontPrimary, 14);
  self.viewThreeLabelOneFont = PopdeemFont(PDThemeFontBold, 14);
  self.viewThreeLabelTwoFont = PopdeemFont(PDThemeFontPrimary, 14);
  self.viewOneActionButtonFont = PopdeemFont(PDThemeFontBold, 14);
  self.viewTwoActionButtonFont = PopdeemFont(PDThemeFontBold, 14);
  self.viewThreeActionButtonFont = PopdeemFont(PDThemeFontBold, 14);
  
  self.viewOneLabelOneColor = PopdeemColor(PDThemeColorPrimaryFont);
  self.viewOneLabelTwoColor = PopdeemColor(PDThemeColorPrimaryFont);
  self.viewTwoLabelOneColor = PopdeemColor(PDThemeColorPrimaryFont);
  self.viewTwoLabelTwoColor = PopdeemColor(PDThemeColorPrimaryFont);
  self.viewThreeLabelOneColor = PopdeemColor(PDThemeColorPrimaryFont);
  self.viewThreeLabelTwoColor = PopdeemColor(PDThemeColorPrimaryFont);
  
  self.viewOneActionButtonColor = [UIColor whiteColor];
  self.viewOneActionButtonBorderColor = PopdeemColor(PDThemeColorPrimaryApp);
  self.viewTwoActionButtonColor = [UIColor whiteColor];
  self.viewOneActionButtonTextColor= PopdeemColor(PDThemeColorPrimaryApp);
  self.viewTwoActionButtonTextColor= PopdeemColor(PDThemeColorPrimaryApp);
  self.viewThreeActionButtonColor = PopdeemColor(PDThemeColorPrimaryApp);
  self.viewThreeActionButtonTextColor = [UIColor whiteColor];
  
  //TODO: Change Images
  self.viewOneImage = PopdeemImage(@"pduikit_facebook_step1");
  self.viewTwoImage = PopdeemImage(@"pduikit_instagramstep2");
  self.viewThreeImage = PopdeemImage(@"pduikit_instagramstep3");
}

@end
