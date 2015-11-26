//
//  PDPopoverViewController.m
//  PopdeemSDK
//
//  Created by John Doran Home on 26/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDNavigationController.h"
#import "PDModalTransitionHandler.h"

@interface PDNavigationController()<UIViewControllerTransitioningDelegate>
@end

@implementation PDNavigationController

#pragma mark - Life

- (void)loadView{
  [super loadView];
  self.extendedLayoutIncludesOpaqueBars = NO;
  self.view.clipsToBounds = YES;
  self.transitioningDelegate = self;
  self.modalPresentationStyle = UIModalPresentationCustom;
  [self defaults];
}


-(void)defaults{
  _tapDismissEnabled = YES;
  _animationSpeed = 0.35f;
  _backgroundShadeColor = [UIColor grayColor];
  _scaleTransform = CGAffineTransformMakeScale(.94, .94);
  _springDamping = 0.88;
  _springVelocity = 14;
  _backgroundShadeAlpha = 0.4;
}

#pragma mark - Actions

- (void)dismissWasTapped{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
  return [self transitionPresenting:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  return [self transitionPresenting:NO];
}

-(PDModalTransitionHandler*)transitionPresenting:(BOOL)presenting{
  PDModalTransitionHandler *animator = [PDModalTransitionHandler new];
  animator.presenting = presenting;
  animator.tapDismissEnabled = _tapDismissEnabled;
  animator.animationSpeed = _animationSpeed;
  animator.backgroundShadeColor = _backgroundShadeColor;
  animator.scaleTransform = _scaleTransform;
  animator.springDamping = _springDamping;
  animator.springVelocity = _springVelocity;
  animator.backgroundShadeAlpha = _backgroundShadeAlpha;
  return animator;
}

@end