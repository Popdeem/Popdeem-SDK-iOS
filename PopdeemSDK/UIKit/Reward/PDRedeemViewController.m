//
//  PDRedeemViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 01/03/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDRedeemViewController.h"
#import <PopdeemSDK/PDBrandStore.h>
#import "PDUtils.h"
#import "PDTheme.h"

@interface PDRedeemViewController () {
  int secondsLeft;
  NSTimer *timer;
  
  UIAlertView *startAlertView;
  UIAlertView *doneAlertView;
}

@end
@implementation PDRedeemViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDRedeemViewController" bundle:podBundle]) {
    return self;
  }
  return nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setNeedsStatusBarAppearanceUpdate];
  // Do any additional setup after loading the view.
  
  //Time left in seconds
  secondsLeft = _reward.countdownTimerDuration;
  
  if (_reward.coverImage) {
    [_logoImageView setImage:_reward.coverImage];
  } else {
    [_logoImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_reward.coverImageUrl]]]];
  }
  
  _logoImageView.layer.borderWidth = 0;
  _logoImageView.layer.cornerRadius = 25;
  _logoImageView.clipsToBounds = YES;
  
  [_brandLabel setText:@""];
  
  NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                      fromDate:[NSDate date]
                                                        toDate:[NSDate dateWithTimeIntervalSince1970:_reward.availableUntil]
                                                       options:0];
  
  NSInteger days = [components day];
  [_timerLabel setFont:PopdeemFont(@"popdeem.redeem.timer.fontName", 55)];
  switch (_reward.type) {
    case PDRewardTypeSweepstake:
      break;
    case PDRewardTypeCoupon:
    case PDRewardTypeInstant:
//      [self.topInfoLabel setText:@"Show this screen at the location"];
//      [self.bottomInfoLabel setText:@"before the timer runs out"];
      [self countDownTimer];
      break;
    default:
      break;
  }
  
  [self.titleLabel setFont:PopdeemFont(@"popdeem.redeem.titleLabel.fontName", 21)];
  [self.titleLabel setTextColor:PopdeemColor(@"popdeem.redeem.titleLabel.fontColor")];
  [self.titleLabel setText:_reward.rewardDescription];
  [self.rulesLabel setFont:PopdeemFont(@"popdeem.redeem.descriptionLabel.fontName", 21)];
  [self.rulesLabel setTextColor:PopdeemColor(@"popdeem.redeem.descriptionLabel.fontColor")];
  [self.rulesLabel setText:_reward.rewardRules];
}

- (void) viewDidAppear:(BOOL)animated {
  
}

- (void) viewWillDisappear:(BOOL)animated {
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  if (alertView == doneAlertView) {
    switch (buttonIndex) {
      case 0:
        //Cancel
        break;
        
      case 1:
        [timer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
      default:
        break;
    }
  }
}

- (void) didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) countDownTimer {
  timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
  [timer fire];
}

- (void) updateTimer {
  if (secondsLeft > 0) {
    secondsLeft--;
    int minutes = (secondsLeft%3600)/60;
    int seconds = (secondsLeft%3600)%60;
    [_timerLabel setText:[NSString stringWithFormat:@"%02d:%02d",minutes,seconds]];
  } else {
    [_timerLabel setText:translationForKey(@"popdeem.redeem.timer.doneText", @"Timer Done")];
    [_timerLabel setFont:PopdeemFont(@"popdeem.redeem.timer.fontName", 14)];
  }
}

- (IBAction)doneAction:(id)sender {
  doneAlertView = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.redeem.doneAlert.title", @"Have you redeemed your reward?")
                                             message:translationForKey(@"popdeem.redeem.doneAlert.body", @"You will not be able to redeem your reward after leaving this screen")
                                            delegate:self
                                   cancelButtonTitle:translationForKey(@"popdeem.redeem.doneAlert.cancelButtonText", @"Cancel")
                                   otherButtonTitles:translationForKey(@"popdeem.redeem.doneAlert.okButtonText", @"Yes, Go!"), nil];
  [doneAlertView show];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the  object to the new view controller.
 }
 */

-(UIStatusBarStyle)preferredStatusBarStyle{
  [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
  return UIStatusBarStyleLightContent;
}

@end
