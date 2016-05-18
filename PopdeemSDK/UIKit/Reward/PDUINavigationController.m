//
//  PDPopoverViewController.m
//  PopdeemSDK
//
//  Created by John Doran Home on 26/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDUINavigationController.h"
#import "PDUIModalTransitionHandler.h"
#import "PDTheme.h"

@interface PDUINavigationController()<UIViewControllerTransitioningDelegate>
@end

@implementation PDUINavigationController

#pragma mark - Life

- (void)loadView{
  [super loadView];
  self.extendedLayoutIncludesOpaqueBars = NO;
  self.view.clipsToBounds = YES;
  self.transitioningDelegate = self;
  self.modalPresentationStyle = UIModalPresentationCustom;
  [self defaults];
  
  
  [[self navigationBar]setBarTintColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];//[UIColor colorWithRed:0.184 green:0.553 blue:0.000 alpha:1.000]];
  [[self navigationBar]setTintColor:PopdeemColor(@"popdeem.colors.primaryInverseColor")];
  self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:PopdeemColor(@"popdeem.colors.primaryInverseColor")};
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

- (void)dismissWasTapped {
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

-(PDUIModalTransitionHandler*)transitionPresenting:(BOOL)presenting{
  PDUIModalTransitionHandler *animator = [PDUIModalTransitionHandler new];
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