//
//  LocationVisor.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 17/03/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "LocationVisor.h"
#import "PDUtils.h"
#import "PDTheme.h"

@implementation LocationVisor

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initForView:(UIView*)view verified:(BOOL)verified {
  NSString *contentString;
  UIImage *image;
  if (verified) {
    contentString = translationForKey(@"popdeem.common.locationVerified", @"Location Verified");
    image = PopdeemImage(@"popdeem.claim.locationVisor.imageName");
  }
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
  [_parent addSubview:self];
  [_parent bringSubviewToFront:self];
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

@end
