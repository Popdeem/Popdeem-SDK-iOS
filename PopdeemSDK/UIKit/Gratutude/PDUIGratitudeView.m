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
    self.frame = [[UIScreen mainScreen] bounds];
    _parent = parent;
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    
    float viewHeight = self.frame.size.height;
    float viewWidth = self.frame.size.width;
    
    float currentY = 0;
    
    float imageHeight = viewHeight * 0.32;
    float topPadding = viewHeight * 0.07;
    
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
    [_titleLabel setText:translationForKey(@"popdeem.gratitude.titleText", @"Sweet Ribs and Burgers!")];
    
    currentY += titleLabelHeight;
    float bodyPadding = viewHeight * 0.022;
    currentY += bodyPadding;
    
    float bodyLabelHeight = viewHeight * 0.12;
    _bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, currentY, viewWidth-(2* labelPadding), bodyLabelHeight)];
    [_bodyLabel setFont:PopdeemFont(PDThemeFontPrimary, 17)];
    [_bodyLabel setTextColor:[UIColor blackColor]];
    [_bodyLabel setTextAlignment:NSTextAlignmentCenter];
    [_bodyLabel setNumberOfLines:3];
    [_bodyLabel setText:translationForKey(@"popdeem.gratitude.bodyText", @"Thanks for sharing. You earned an additional 10 points to your account and moved up in status.")];
    
    currentY += bodyLabelHeight;
    
    
    
    return self;
  }
  return nil;
}

- (void) viewWillAppear {
}

- (void) didMoveToSuperview {
  [self addSubview:_imageView];
  [self addSubview:_titleLabel];
  [self addSubview:_bodyLabel];
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
