//
//  PDUIGratitudeView.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 11/02/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDUIGratitudeView.h"
#import <UIKit/UIKit.h>
#import "PopdeemSDK.h"
#import "PDUser.h"
#import "PDTheme.h"
#import "PDUIGratitudeViewController.h"
#import "PDCustomer.h"

@implementation PDUIGratitudeView
- (PDUIGratitudeView*) initForParent:(PDUIGratitudeViewController*)parent type:(PDGratitudeType)type reward:(PDReward*)reward {
  self.reward = reward;
  return [self initForParent:parent type:type];
}

- (PDUIGratitudeView*) initForParent:(PDUIGratitudeViewController*)parent type:(PDGratitudeType)type {
  if (self = [super init]) {
    self.type = type;
    self.frame = [[UIScreen mainScreen] bounds];
    _parent = parent;
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    
    float viewHeight = self.frame.size.height;
    float viewWidth = self.frame.size.width;
    
    float currentY = 0;
    
    float imageHeight = 120;
    float topPadding = viewHeight * 0.15;
    
    //Icon Image
    currentY = topPadding;
    float imagePadding = (viewWidth - imageHeight)/2;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imagePadding, currentY, imageHeight, imageHeight)];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    currentY += imageHeight;
    
    currentY += viewHeight * 0.05;
    float labelPadding = viewWidth * 0.1;
    float titleLabelHeight = viewHeight*0.04;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, currentY, viewWidth-(2* labelPadding), titleLabelHeight)];
    [_titleLabel setFont:PopdeemFont(PDThemeFontBold, 22)];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setNumberOfLines:0];
    
    currentY += titleLabelHeight;
    float bodyPadding = viewHeight * 0.022;
    currentY += bodyPadding;
    
    float bodyLabelHeight = viewHeight * 0.12;
    _bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, currentY, viewWidth-(2* labelPadding), bodyLabelHeight)];
    [_bodyLabel setFont:PopdeemFont(PDThemeFontPrimary, 17)];
    [_bodyLabel setTextColor:[UIColor blackColor]];
    [_bodyLabel setTextAlignment:NSTextAlignmentCenter];
    [_bodyLabel setNumberOfLines:3];
    
    [self setTitleAndBody];
    
    currentY += bodyLabelHeight;
    float gratitudePadding = viewHeight * 0.04;
    currentY += gratitudePadding;
    float progressHeight = viewHeight * 0.12;
    //TODO: User real value
    if ([[PDCustomer sharedInstance] usesAmbassadorFeatures]) {
      float userValue = (_type == PDGratitudeTypeConnect) ? 0 : [[PDUser sharedInstance] advocacyScore];
      BOOL increment = (userValue < 90) ? YES : NO;
      _progressView = [[PDUIGratitudeProgressView alloc] initWithInitialValue:userValue frame:CGRectMake(0, currentY, viewWidth, progressHeight) increment:increment];
    }
    
    float buttonHeight = 52;
    
    _profileButton = [[UIButton alloc] initWithFrame:CGRectMake(labelPadding, viewHeight - 30 - buttonHeight, viewWidth - (2* labelPadding), buttonHeight)];
    [_profileButton setBackgroundColor:[UIColor whiteColor]];
    _profileButton.layer.cornerRadius = 8.0;
    _profileButton.layer.borderWidth = 2.0;
    _profileButton.layer.borderColor = PopdeemColor(PDThemeColorSecondaryApp).CGColor;
    _profileButton.titleLabel.textColor = PopdeemColor(PDThemeColorSecondaryApp);
    _profileButton.titleLabel.font = PopdeemFont(PDThemeFontBold, 17);
    [_profileButton setTitle:translationForKey(@"popdeem.gratitude.buttonTitle", @"Go to Profile") forState:UIControlStateNormal];
    [_profileButton setTitleColor:PopdeemColor(PDThemeColorSecondaryApp) forState:UIControlStateNormal];
    [_profileButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    
    float infoTop = currentY + progressHeight + 15;
    float infoBottom = viewHeight - 30 - buttonHeight - 15;
    float infoHeight = infoBottom - infoTop;
    
    if ([[PDCustomer sharedInstance] usesAmbassadorFeatures]) {
      _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, infoTop, viewWidth - (2*labelPadding), infoHeight)];
      [_infoLabel setFont:PopdeemFont(PDThemeFontPrimary, 12)];
      [_infoLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
      [_infoLabel setText:translationForKey(@"popdeem.gratitude.infoText", @"Unlock new rewards and VIP offers as you move up in status.")];
      [_infoLabel setTextAlignment:NSTextAlignmentCenter];
      [_infoLabel setNumberOfLines:0];
    }
    return self;
  }
  return nil;
}

- (void) setTitleAndBody {
  NSString *stringKey;
  NSString *imageKey;
  NSInteger numVariations = 0;
  NSInteger variationNumber = 0;
  switch (_type) {
    case PDGratitudeTypeShare:
      if (self.reward.type == PDRewardTypeCoupon) {
        if (self.reward.creditString != nil) {
          stringKey = @"popdeem.gratitude.creditCoupon";
          imageKey = @"popdeem.images.gratitudeCreditCoupon%i";
          numVariations = [[NSUserDefaults standardUserDefaults] integerForKey:PDGratCreditCouponVariations];
          variationNumber = [self getAndIncrementLastVariationForKey:PDGratitudeLastCreditCouponUsed limitKey:PDGratCreditCouponVariations];
        } else {
          stringKey = @"popdeem.gratitude.coupon";
          imageKey = @"popdeem.images.gratitudeCoupon%i";
          numVariations = [[NSUserDefaults standardUserDefaults] integerForKey:PDGratCouponVariations];
          variationNumber = [self getAndIncrementLastVariationForKey:PDGratitudeLastCouponUsed limitKey:PDGratCouponVariations];
        }
      } else {
        stringKey = @"popdeem.gratitude.sweepstake";
        imageKey = @"popdeem.images.gratitudeSweepstake%i";
        numVariations = [[NSUserDefaults standardUserDefaults] integerForKey:PDGratSweepstakeVariations];
        variationNumber = [self getAndIncrementLastVariationForKey:PDGratitudeLastSweepstakeUsed limitKey:PDGratSweepstakeVariations];
      }
      break;
    case PDGratitudeTypeConnect:
      stringKey = @"popdeem.gratitude.connect";
      imageKey = @"popdeem.images.gratitudeConnect%i";
      numVariations = [[NSUserDefaults standardUserDefaults] integerForKey:PDGratConnectVariations];
      variationNumber = [self getAndIncrementLastVariationForKey:PDGratitudeLastConnectUsed limitKey:PDGratConnectVariations];
      break;
    default:
      stringKey = @"popdeem.gratitude.share.titleText";
      break;
  }
  NSString *title = @"";
  NSString *body = @"";
  UIImage *image;
  
  if (numVariations == 0) {
    //No variations in the Strings file, return the defaults.
    //No need for translationForKey here - if there were any strings, variations would be >=1
    switch (_type) {
      case PDGratitudeTypeShare:
        if (self.reward.type == PDRewardTypeCoupon) {
          if (self.reward.creditString != nil) {
            title = @"You're Brilliant!";
            body = [NSString stringWithFormat:@"Thanks for sharing. %@ has been added to your account. Enjoy!", self.reward.creditString];
          } else {
            title = @"Great Job!";
            body = @"Thanks for sharing, your reward has been added to your profile. Enjoy!";
          }
        } else {
          title = @"Awesome!";
          body = @"Thanks for sharing, you’ve been entered into the competition.";
        }
        break;
      case PDGratitudeTypeConnect:
        title = @"Welcome!";
        body = @"Thanks for connecting, start sharing to earn more rewards and enter amazing competitions.";
        break;
      default:
        title = @"Great Job!";
        body = @"Thanks for sharing, your reward has been added to your profile. Enjoy!";
        break;
    }
    image = PopdeemImage(@"popdeem.images.loginImage");
  } else if (numVariations == 1) {
    //Return 1
    NSString *titleKey = [NSString stringWithFormat:@"%@.title.%i",stringKey, 1];
    NSString *bodyKey = [NSString stringWithFormat:@"%@.body.%i",stringKey, 1];
    if (self.reward.creditString != nil) {
      title = translationForKey(titleKey, @"You're Brilliant!");
      body = [NSString stringWithFormat:translationForKey(bodyKey, @"%@ was added to your account."), self.reward.creditString];
    } else {
      title = translationForKey(titleKey, @"You're Brilliant!");
      body = translationForKey(bodyKey, @"Unlock new rewards and VIP offers as you move up in status.");
    }
    NSString *imageString = [NSString stringWithFormat:imageKey, 1];
    image = PopdeemImage(imageString);
  } else {
    //Return next item in cycle
    NSString *titleKey = [NSString stringWithFormat:@"%@.title.%ld",stringKey, (long)variationNumber];
    NSString *bodyKey = [NSString stringWithFormat:@"%@.body.%ld",stringKey, (long)variationNumber];
    if (self.reward.creditString != nil) {
      title = translationForKey(titleKey, @"You're Brilliant!");
      body = [NSString stringWithFormat:translationForKey(bodyKey, @"%@ was added to your account."), self.reward.creditString];
    } else {
      title = translationForKey(titleKey, @"You're Brilliant!");
      body = translationForKey(bodyKey, @"Unlock new rewards and VIP offers as you move up in status.");
    }
    NSString *imageString = [NSString stringWithFormat:imageKey, variationNumber];
    image = PopdeemImage(imageString);
  }
  
  [_titleLabel setText:title];
  [_bodyLabel setText:body];
  [_imageView setImage:image];
  
}

- (NSInteger) getAndIncrementLastVariationForKey:(NSString*)key limitKey:(NSString*)limitKey {
  NSInteger lastVariation = [[NSUserDefaults standardUserDefaults] integerForKey:key];
  NSInteger limit = [[NSUserDefaults standardUserDefaults] integerForKey:limitKey];
  if (limit == 0) return 0;
  lastVariation += 1;
  if (lastVariation > limit) {
    lastVariation = 1;
  }
  [[NSUserDefaults standardUserDefaults] setInteger:lastVariation forKey:key];
  return lastVariation;
}

- (NSString*) randomDefaultTitle {
  switch (_type) {
    case PDGratitudeTypeShare:
      return translationForKey(@"popdeem.gratitude.share.titleText", @"You’re Brilliant!");
      break;
    case PDGratitudeTypeConnect:
      return translationForKey(@"popdeem.gratitude.connect.titleText", @"Welcome!");
      break;
    default:
      return translationForKey(@"popdeem.gratitude.share.titleText", @"You’re Brilliant!");
      break;
  }
}

- (NSString*)body {
  if ([[PDCustomer sharedInstance] usesAmbassadorFeatures]) {
    NSInteger incrementPoints = [[[PDCustomer sharedInstance] incrementAdvocacyPoints] integerValue];
    switch (_type) {
      case PDGratitudeTypeShare:
        return [NSString stringWithFormat:translationForKey(@"popdeem.gratitude.share.bodyText", @"Thanks for sharing. You earned an additional %d points to your account and moved up in status."), incrementPoints];
        break;
      case PDGratitudeTypeConnect:
        return [NSString stringWithFormat:translationForKey(@"popdeem.gratitude.connect.bodyText", @"You earned %d points for connecting. Share photo’s with #TheCasualPint to earn additional rewards!"), incrementPoints];
        break;
      default:
        return [NSString stringWithFormat:translationForKey(@"popdeem.gratitude.share.bodyText", @"Thanks for sharing. You earned an additional %d points to your account and moved up in status."), incrementPoints];
        break;
    }
  } else {
    switch (_type) {
      case PDGratitudeTypeShare:
        return [NSString stringWithFormat:@"%@", translationForKey(@"popdeem.gratitude.share.bodyText", @"Thanks for sharing, your reward has been added to your profile. Enjoy!")];
        break;
      case PDGratitudeTypeConnect:
        return [NSString stringWithFormat:@"%@", translationForKey(@"popdeem.gratitude.connect.bodyText", @"Thanks for connecting, start sharing to earn more rewards and enter amazing competitions.")];
        break;
      default:
        return [NSString stringWithFormat:@"%@", translationForKey(@"popdeem.gratitude.share.bodyText", @"Thanks for sharing, your reward has been added to your profile. Enjoy!")];
        break;
    }
  }
}

- (void) viewWillAppear {
}

- (void) didMoveToSuperview {
  [self addSubview:_imageView];
  [self addSubview:_titleLabel];
  [self addSubview:_bodyLabel];
  [self addSubview:_progressView];
  [self addSubview:_infoLabel];
  [self addSubview:_profileButton];
}

- (void) showAnimated:(BOOL)animated {
  if (animated) {
    CATransition *loaderIn =[CATransition animation];
    [loaderIn setDuration:0.5];
    [loaderIn setType:kCATransitionReveal];
    [loaderIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[self layer] addAnimation:loaderIn forKey:kCATransitionReveal];
  }
  [self setHidden:NO];
  [_parent.view addSubview:self];
  [_parent.view bringSubviewToFront:self];
}

- (void) hideAnimated:(BOOL)animated {
  if (animated) {
    [self.layer removeAllAnimations];
    CATransition *loaderOut =[CATransition animation];
    [loaderOut setDuration:0.5];
    [loaderOut setType:kCATransitionReveal];
    [loaderOut setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[self layer] addAnimation:loaderOut forKey:kCATransitionReveal];
  }
  [self removeFromSuperview];
}

- (void) dismissAction {
  [_parent dismissAction];
}

- (UIImage*) image {
  NSInteger variations = 0;
  NSString *imageKey;
  switch (self.type) {
    case PDGratitudeTypeShare:
      if (self.reward.type == PDRewardTypeCoupon) {
        if (self.reward.creditString != nil) {
          if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PDGratCreditCouponVariations"]) {
            variations = [[NSUserDefaults standardUserDefaults] integerForKey:@"PDGratCreditCouponVariations"];
            imageKey = @"popdeem.images.gratitudeCreditCoupon%i";
            break;
          } else {
            imageKey = @"popdeem.images.gratitudeCreditCouponDefault%i";
            break;
          }
        } else {
          if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PDGratCouponVariations"]) {
            variations = [[NSUserDefaults standardUserDefaults] integerForKey:@"PDGratCouponVariations"];
            imageKey = @"popdeem.images.gratitudeCoupon%i";
            break;
          } else {
            imageKey = @"popdeem.images.gratitudeCouponDefault";
            break;
          }
        }
      } else if (self.reward.type == PDRewardTypeSweepstake) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PDGratSweepstakeVariations"]) {
          variations = [[NSUserDefaults standardUserDefaults] integerForKey:@"PDGratSweepstakeVariations"];
          imageKey = @"popdeem.images.gratitudeSweepstake%i";
          break;
        } else {
          imageKey = @"popdeem.images.gratitudeSweepstakeDefault%i";
          break;
        }
      }
      break;
    case PDGratitudeTypeConnect:
      if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PDGratConnectVariations"]) {
        variations = [[NSUserDefaults standardUserDefaults] integerForKey:@"PDGratConnectVariations"];
        imageKey = @"popdeem.images.gratitudeConnect%i";
        break;
      } else {
        imageKey = @"popdeem.images.gratitudeConnectDefault%i";
        break;
      }
    default:
      break;
  }
  
  if (variations == 0) {
    //Must get the SDK defaults
    //There will be 3 defaults for each in the SDK
    int rndValue = 1 + arc4random() % (3 - 1);
    NSString *imageString = [NSString stringWithFormat:imageKey, rndValue];
    UIImage *image = PopdeemImage(imageString);
    return image;
  }
  if (variations == 1) {
    NSString *imageString = [NSString stringWithFormat:imageKey, 1];
    UIImage *image = PopdeemImage(imageString);
    return image;
  }
  else {
    int rndValue = 1 + arc4random() % (variations - 1);
    NSString *imageString = [NSString stringWithFormat:imageKey, rndValue];
    UIImage *image = PopdeemImage(imageString);
    return image;
  }
  
}

@end
