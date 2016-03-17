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
  self = [super init];
  _parent = view;
  NSString *contentString;
  UIImage *image;
  if (verified) {
    contentString = translationForKey(@"popdeem.common.locationVerified", @"Location Verified");
    image = [UIImage imageNamed:@"pd_tickG"];
  } else {
    contentString = translationForKey(@"popdeem.common.locationFailed", @"You must be at this location to claim this reward");
    image = [UIImage imageNamed:@"pd_tickG"];
  }
  self.frame = CGRectMake(40, 0, _parent.frame.size.width-80, 40);
  self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
  
  _imageView = [[UIImageView alloc] initWithImage:image];
  [_imageView setFrame:CGRectMake(10, 10, 20, 20)];
  [_imageView setContentMode:UIViewContentModeScaleAspectFill];
  [self addSubview:_imageView];
  
  CGRect titleRect;
  if (verified) {
    titleRect = CGRectMake(40, 0, self.frame.size.width-45, 40);
  } else {
    titleRect = CGRectMake(40, 0, self.frame.size.width-75, 40);
  }
  _titleLabel = [[UILabel alloc] init];
  [_titleLabel setFrame:titleRect];
  [_titleLabel setNumberOfLines:2];
  [_titleLabel setText:contentString];
  [_titleLabel setFont:PopdeemFont(@"popdeem.claim.fontName", 14)];
  [_titleLabel setTextColor:[UIColor whiteColor]];
  [self addSubview:_titleLabel];
  
  return self;
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
