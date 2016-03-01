//
//  PDRedeemViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 01/03/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDRedeemViewController.h"
#import <PopdeemSDK/PDBrandStore.h>
#import "FlurryLogger.h"

@interface RedeemViewController () {
  int secondsLeft;
  NSTimer *timer;
  
  UIAlertView *startAlertView;
  UIAlertView *doneAlertView;
}

@end
@implementation PDRedeemViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  [self setNeedsStatusBarAppearanceUpdate];
  // Do any additional setup after loading the view.
  
  //Time left in seconds
  secondsLeft = 600;
  
  if (_reward.coverImage) {
    [_logoImageView setImage:_reward.coverImage];
  } else {
    [_logoImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_reward.coverImageUrl]]]];
  }
  
  _logoImageView.layer.borderWidth = 0;
  _logoImageView.layer.cornerRadius = 25;
  _logoImageView.clipsToBounds = YES;
  
  [_brandLabel setText:@""];
  
  [self.titleLabel setText:_reward.rewardDescription];
  [self.rulesLabel setText:_reward.rewardRules];
  
  NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                      fromDate:[NSDate date]
                                                        toDate:[NSDate dateWithTimeIntervalSince1970:_reward.availableUntil]
                                                       options:0];
  
  NSInteger days = [components day];
  
  switch (_reward.type) {
    case PDRewardTypeSweepstake:
      [self.topInfoLabel setText:@"Draw takes place in"];
      [self.bottomInfoLabel setText:@""];
      [self.doneButton setHidden:YES];
      if (days > 1) {
        [_timerLabel setText:[NSString stringWithFormat:@"%ld days",(long)days]];
      }
      if (days == 1) {
        [_timerLabel setText:@"1 day"];
      }
      if (days == 0) {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitHour
                                                            fromDate:[NSDate date]
                                                              toDate:[NSDate dateWithTimeIntervalSince1970:_reward.availableUntil]
                                                             options:0];
        NSInteger hours = [components hour];
        [_timerLabel setText:[NSString stringWithFormat:@"%ld hours",(long)hours]];
      }
      if (days < 0) {
        [_timerLabel setText:@""];
        [self.topInfoLabel setText:@"Draw has taken place"];
        [self.topInfoLabel setText:@"stand by for notification."];
      }
      
      break;
    case PDRewardTypeCoupon:
    case PDRewardTypeInstant:
      [self.topInfoLabel setText:@"Show this screen at the location"];
      [self.bottomInfoLabel setText:@"before the timer runs out"];
      [self countDownTimer];
      break;
    default:
      break;
  }
  
  
}

- (void) viewDidAppear:(BOOL)animated {
  [FlurryLogger logEvent:@"Redeem Page Opened" params:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
  [FlurryLogger logEvent:@"Redeem Page Closed" params:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  if (alertView == doneAlertView) {
    switch (buttonIndex) {
      case 0:
        //Cancel
        break;
        
      case 1:
        [timer invalidate];
        [self.navigationController popToRootViewControllerAnimated:YES];
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
    [_timerLabel setText:@"Timer Done"];
    [_timerLabel setFont:[UIFont systemFontOfSize:14]];
  }
}

- (IBAction)doneAction:(id)sender {
  doneAlertView = [[UIAlertView alloc] initWithTitle:@"Have you redeemed your reward?"
                                             message:@"You will not be able to redeem your reward after leaving this screen"
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:@"Yes, go!", nil];
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
