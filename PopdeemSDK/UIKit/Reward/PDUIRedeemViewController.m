//
//  PDRedeemViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 01/03/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PopdeemSDK.h"
#import "PDUIRedeemViewController.h"
#import "PDBrandStore.h"
#import "PDUtils.h"
#import "PDTheme.h"

@interface PDUIRedeemViewController () {
  NSUInteger secondsLeft;
  NSTimer *timer;
	CFAbsoluteTime stopTime;
  UIAlertView *startAlertView;
  UIAlertView *doneAlertView;
}

@end
@implementation PDUIRedeemViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
  if (self = [self initWithNibName:@"PDUIRedeemViewController" bundle:podBundle]) {
    return self;
  }
  return nil;
}

- (void)viewDidLoad {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
	
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
  
//  NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
////  NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
//                                                      fromDate:[NSDate date]
//                                                        toDate:[NSDate dateWithTimeIntervalSince1970:_reward.availableUntil]
//                                                       options:0];
	
//  NSInteger days = [components day];
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
  
  [self.titleLabel setFont:PopdeemFont(PDThemeFontPrimary, 16)];
  [self.titleLabel setNumberOfLines:3];
  [self.titleLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
  [self.titleLabel setText:_reward.rewardDescription];
	
  [self.rulesLabel setFont:PopdeemFont(PDThemeFontPrimary, 13)];
  [self.rulesLabel setNumberOfLines:4];
  [self.rulesLabel setTextColor:PopdeemColor(PDThemeColorSecondaryFont)];
  [self.rulesLabel setText:_reward.rewardRules];
    
    NSString *rewardActionColor;
    
    if (PopdeemThemeHasValueForKey(PDThemeColorRewardAction)) {
        rewardActionColor = PopdeemColor(PDThemeColorRewardAction);
    } else {
        rewardActionColor = PopdeemColor(PDThemeColorSecondaryFont);
    }
	
	[self.timerLabel setFont:PopdeemFont(PDThemeFontBold, 55)];
	[self.timerLabel setTextColor:rewardActionColor];
  
    NSString *buttonColor;
    
    if (PopdeemThemeHasValueForKey(PDThemeColorButtons)) {
        buttonColor = PopdeemColor(PDThemeColorButtons);
    } else {
        buttonColor = PopdeemColor(PDThemeColorPrimaryApp);
    }
    
  [self.doneButton setBackgroundColor:buttonColor];
  [self.doneButton setTitle:translationForKey(@"popdeem.redeem.doneButton.title", @"Done") forState:UIControlStateNormal];
  [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.doneButton.titleLabel setFont:PopdeemFont(PDThemeFontPrimary, 18.0)];
  
  if (PopdeemThemeHasValueForKey(@"popdeem.images.tableViewBackgroundImage")) {
    UIImageView *tvbg = [[UIImageView alloc] initWithFrame:self.view.frame];
    [tvbg setImage:PopdeemImage(@"popdeem.images.tableViewBackgroundImage")];
    [self.view addSubview:tvbg];
    [self.view sendSubviewToBack:tvbg];
  }
}

- (void) viewDidAppear:(BOOL)animated {
  
}

- (void) viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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
		[timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
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

- (void) appWillResignActive:(id)sender {
	stopTime = CFAbsoluteTimeGetCurrent();
}

- (void) appWillTerminate:(id)sender {
	[timer invalidate];
}

- (void) applicationWillEnterForeground:(id)sender {
	CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
	double delta = startTime - stopTime;
	secondsLeft -= delta;
}


@end
