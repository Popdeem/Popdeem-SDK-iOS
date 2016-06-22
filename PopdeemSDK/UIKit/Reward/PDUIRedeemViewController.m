//
//  PDRedeemViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 01/03/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIRedeemViewController.h"
#import "PDBrandStore.h"
#import "PDUtils.h"
#import "PDTheme.h"

@interface PDUIRedeemViewController () {
  int secondsLeft;
  NSTimer *timer;
  
  UIAlertView *startAlertView;
  UIAlertView *doneAlertView;
}

@end
@implementation PDUIRedeemViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDUIRedeemViewController" bundle:podBundle]) {
    return self;
  }
  return nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setNeedsStatusBarAppearanceUpdate];
  [self.navigationItem setHidesBackButton:YES];
  self.title = translationForKey(@"popdeem.redeem.title", @"Redeem");
  // Do any additional setup after loading the view.
  
  //Time left in seconds
  secondsLeft = _reward.countdownTimerDuration;
  
  if (_reward.coverImage) {
    [_logoImageView setImage:_reward.coverImage];
  } else {
    [_logoImageView setImage:PopdeemImage(@"popdeem.images.defaultItemImage")];
  }
  
  _logoImageView.layer.borderWidth = 0;
  _logoImageView.layer.cornerRadius = 22;
  _logoImageView.clipsToBounds = YES;
  
  [_brandLabel setText:@""];
  
  NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                      fromDate:[NSDate date]
                                                        toDate:[NSDate dateWithTimeIntervalSince1970:_reward.availableUntil]
                                                       options:0];
  
  NSInteger days = [components day];
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
  
  [self.titleLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 18)];
  [self.titleLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryFontColor")];
  [self.titleLabel setText:_reward.rewardDescription];
	
  [self.rulesLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 15)];
  [self.rulesLabel setTextColor:PopdeemColor(@"popdeem.colors.secondaryFontColor")];
  [self.rulesLabel setText:_reward.rewardRules];
	
	[self.timerLabel setFont:PopdeemFont(@"popdeem.fonts.boldFont", 55)];
	[self.timerLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
  
  [self.doneButton setBackgroundColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
  [self.doneButton setTitle:translationForKey(@"popdeem.redeem.doneButton.title", @"Done") forState:UIControlStateNormal];
  [self.doneButton setTitleColor:PopdeemColor(@"popdeem.colors.primaryInverseColor") forState:UIControlStateNormal];
  [self.doneButton.titleLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 18.0)];
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
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
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
