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

@implementation PDUIGratitudeView

- (PDUIGratitudeView*) initForView:(UIView*)parent {
  if (self = [super init]) {
    self.frame = parent.frame;
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    
    float viewHeight = self.frame.size.height;
    float viewWidth = self.frame.size.width;
    
    float currentY = 0;
    
    float imageHeight = viewHeight * 0.32;
    float topPadding = viewHeight * 0.07;
    
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
    return self;
  }
  return nil;
}

- (void) didMoveToSuperview {
  [self addSubview:_imageView];
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
