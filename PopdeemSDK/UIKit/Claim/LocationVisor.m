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

@interface LocationVisor()
@property (nonatomic) CGRect viewRect;
@end

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
    _viewRect = CGRectMake(30, -5, _parent.frame.size.width-60, 45);
  } else {
    contentString = translationForKey(@"popdeem.common.locationFailed", @"You must be at this location to claim this reward");
    image = [UIImage imageNamed:@"pd_tickG"];
    _viewRect = CGRectMake(30, -5, _parent.frame.size.width-60, 65);
  }
  
  [self setFrame:CGRectMake(30, -45, _parent.frame.size.width-60, 45)];
  self.backgroundColor = PopdeemColor(@"popdeem.claim.locationVisor.backgroundColor");
  
  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  maskLayer.frame = self.bounds;
  maskLayer.path  = maskPath.CGPath;
  self.layer.mask = maskLayer;
  
  self.layer.cornerRadius = 5.0;
  self.layer.masksToBounds = YES;
  
  _imageView = [[UIImageView alloc] initWithImage:image];
  [_imageView setFrame:CGRectMake(10, 15, 20, 20)];
  [_imageView setContentMode:UIViewContentModeScaleAspectFill];
  [self addSubview:_imageView];
  
  CGRect titleRect;
  if (verified) {
    titleRect = CGRectMake(5, 5, self.frame.size.width-10, 40);
  } else {
    titleRect = CGRectMake(40, 5, self.frame.size.width-80, 60);
  }
  _titleLabel = [[UILabel alloc] init];
  [_titleLabel setFrame:titleRect];
  [_titleLabel setNumberOfLines:2];
  [_titleLabel setText:contentString];
  [_titleLabel setFont:PopdeemFont(@"popdeem.claim.locationVisor.font", 14)];
  [_titleLabel setTextColor:[UIColor whiteColor]];
  [_titleLabel setTextAlignment:NSTextAlignmentCenter];
  [self addSubview:_titleLabel];
  
  return self;
}

- (void) showAnimated:(BOOL)animated {
  [UIView setAnimationsEnabled:YES];
  [self setHidden:NO];
  [_parent addSubview:self];
  [_parent bringSubviewToFront:self];
  if (animated) {
    CATransition *loaderIn =[CATransition animation];
    [loaderIn setDuration:0.9];
    [loaderIn setType:kCATransitionFromTop];
    [loaderIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self layer] addAnimation:loaderIn forKey:kCATransitionFromTop];
    
    [UIView animateWithDuration:1.0 animations:^{
      [self setFrame:_viewRect];
    }];
  } else {
    [self setFrame:_viewRect];
  }
}

- (void) hideAnimated:(BOOL)animated {
  if (animated) {
    [self.layer removeAllAnimations];
    CATransition *loaderOut =[CATransition animation];
    [loaderOut setDuration:0.5];
    [loaderOut setType:kCATransitionFromBottom];
    [loaderOut setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self layer] addAnimation:loaderOut forKey:kCATransitionFromBottom];
    [UIView animateWithDuration:1.0 animations:^{
      [self setFrame:CGRectMake(30, -45, _parent.frame.size.width-60, 40)];
    }];
  } else {
    [self setFrame:CGRectMake(30, -45, _parent.frame.size.width-60, 40)];
  }
//  [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.1];
}

@end
