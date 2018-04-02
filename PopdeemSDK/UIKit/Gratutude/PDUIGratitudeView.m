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
    UIImage *image;
    if (PopdeemThemeHasValueForKey(@"popdeem.images.ambassadorIconImage")) {
      image = PopdeemImage(@"popdeem.images.ambassadorIconImage");
    } else {
      image = PopdeemImage(@"ambassador_icon_default");
    }
    [_imageView setImage:image];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    currentY += imageHeight;
    
    currentY += viewHeight * 0.03;
    float labelPadding = viewWidth * 0.1;
    float titleLabelHeight = viewHeight*0.04;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, currentY, viewWidth-(2* labelPadding), titleLabelHeight)];
    [_titleLabel setFont:PopdeemFont(PDThemeFontBold, 22)];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setText:[self title]];
    
    currentY += titleLabelHeight;
    float bodyPadding = viewHeight * 0.022;
    currentY += bodyPadding;
    
    float bodyLabelHeight = viewHeight * 0.12;
    _bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, currentY, viewWidth-(2* labelPadding), bodyLabelHeight)];
    [_bodyLabel setFont:PopdeemFont(PDThemeFontPrimary, 14)];
    [_bodyLabel setTextColor:[UIColor blackColor]];
    [_bodyLabel setTextAlignment:NSTextAlignmentCenter];
    [_bodyLabel setNumberOfLines:3];
    [_bodyLabel setText:[self body]];
    
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

- (NSString*) title {
  switch (_type) {
    case PDGratitudeTypeShare:
      return translationForKey(@"popdeem.gratitude.share.noAmbassador.titleText", @"You’re Brilliant!");
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
    NSInteger incrementPoints = [[PDCustomer sharedInstance] incrementAdvocacyPoints];
    switch (_type) {
      case PDGratitudeTypeShare:
        return [NSString stringWithFormat:translationForKey(@"popdeem.gratitude.share.bodyText", @"Thanks for sharing. You earned an additional %d points to your account and moved up in status."), incrementPoints];
        break;
      case PDGratitudeTypeConnect:
        return [NSString stringWithFormat:translationForKey(@"popdeem.gratitude.connect.bodyText", @"You earned %d points for connecting. Share photo’s with #RibsandBurgers to earn additional rewards!"), incrementPoints];
        break;
      default:
        return [NSString stringWithFormat:translationForKey(@"popdeem.gratitude.share.bodyText", @"Thanks for sharing. You earned an additional %d points to your account and moved up in status."), incrementPoints];
        break;
    }
  } else {
    switch (_type) {
      case PDGratitudeTypeShare:
        return [NSString stringWithFormat:translationForKey(@"popdeem.gratitude.share.bodyText", @"Thanks for sharing, your reward has been added to your profile. Enjoy!")];
        break;
      case PDGratitudeTypeConnect:
        return [NSString stringWithFormat:translationForKey(@"popdeem.gratitude.connect.bodyText", @"Thanks for connecting, start sharing to earn more rewards and enter amazing competitions.")];
        break;
      default:
        return [NSString stringWithFormat:translationForKey(@"popdeem.gratitude.share.bodyText", @"Thanks for sharing, your reward has been added to your profile. Enjoy!")];
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
@end
