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
  
  if (!_controller.facebookInstalled) {
    self.viewOneLabelOneText = translationForKey(@"popdeem.facebook.share.stepOne.label1.noapp", @"Facebook not installed");
    self.viewOneImage = PopdeemImage(@"pduikit_facebook_noapp");
      
      
      if (_controller.parent.reward.forcedTag && ![_controller.parent.reward.forcedTag  isEqual: @"#"]) {
      self.viewOneLabelTwoText = [NSString stringWithFormat:translationForKey(@"popdeem.facebook.share.stepOne.label2.noapp", @"Make your post on Facebook, making sure to include the hashtag %@. Then use the scan feature on the previous screen to claim your reward."), _controller.parent.reward.forcedTag];
        
    } else if (_controller.parent.reward.action == PDRewardActionCheckin) {
        
    NSString *defaultLocationString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *locationString = translationForKey(@"popdeem.claim.checkinLocation", defaultLocationString);
        
      self.viewOneLabelTwoText = [NSString stringWithFormat:translationForKey(@"popdeem.facebook.share.stepOne.label2.noapp", @"Make your post on Facebook, making sure to check-in at a %@ location. Then use the scan feature on the previous screen to claim your reward."), locationString];
        
    } else {
        self.viewOneLabelTwoText = translationForKey(@"popdeem.facebook.share.stepOne.label2", @"Make your post on Facebook. Then use the scan feature on the previous screen to claim your reward.");
    }
  } else {
   
      // Need to get handle on reward
      
      NSString *tutorialImage = @"";
      
    if (_controller.parent.reward.action == PDRewardActionPhoto) {
          tutorialImage = @"pduikit_facebook_step1";
      }
      else if (_controller.parent.reward.action == PDRewardActionCheckin) {
          tutorialImage = @"pduikit_fb_checkin";
      }
    
      self.viewOneImage = PopdeemImage(tutorialImage);

    if (_controller.image) {
      self.viewOneLabelOneText = translationForKey(@"popdeem.facebook.share.stepOne.label1.image", @"Share your photo");
    } else {
      self.viewOneLabelOneText = translationForKey(@"popdeem.facebook.share.stepOne.label1.checkin", @"Check-in");
    }
    if (_controller.parent.reward.action == PDRewardActionPhoto && _controller.parent.reward.forcedTag) {
        self.viewOneLabelTwoText = [NSString stringWithFormat:translationForKey(@"popdeem.facebook.share.stepOne.label2", @"Your post must include the hashtag %@, or you will be unable to claim your reward."), _controller.parent.reward.forcedTag];
        
    } else if (_controller.parent.reward.action == PDRewardActionCheckin) {
        
        NSString *defaultLocationString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        NSString *locationString = translationForKey(@"popdeem.claim.checkinLocation", defaultLocationString);
        
        self.viewOneLabelTwoText = [NSString stringWithFormat:translationForKey(@"popdeem.facebook.share.stepOne.label2", @"You must check-in at a %@ location, or you will be unable to claim your reward."), locationString];
    }
    else {
      self.viewOneLabelTwoText = translationForKey(@"popdeem.facebook.share.stepOne.label2", @"Your post must include the specified hashtag, or you will be unable to claim your reward.");
    }
  }
  

  self.viewOneActionButtonText = translationForKey(@"popdeem.facebook.share.stepThree.buttonText", @"Okay, Gotcha");
 
  self.viewOneLabelOneFont = PopdeemFont(PDThemeFontBold, 14);
  self.viewOneLabelTwoFont = PopdeemFont(PDThemeFontPrimary, 14);
  self.viewOneActionButtonFont = PopdeemFont(PDThemeFontBold, 14);
  
  self.viewOneLabelOneColor = PopdeemColor(PDThemeColorPrimaryFont);
  self.viewOneLabelTwoColor = PopdeemColor(PDThemeColorPrimaryFont);
  
  self.viewOneActionButtonColor = PopdeemColor(PDThemeColorButtons);
  self.viewOneActionButtonBorderColor = [UIColor whiteColor];

}

@end
