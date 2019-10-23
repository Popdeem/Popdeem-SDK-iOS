//
//  PDMultiLoginViewControllerV2.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/01/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import "PDMultiLoginViewControllerV2.h"
#import "PDSocialMediaManager.h"
#import "PDMultiLoginViewModelV2.h"
#import "PDTheme.h"
#import "PDConstants.h"
#import "PDUser.h"
#import "PDAbraClient.h"
#import "PDUser+Facebook.h"
#import "PDLogger.h"
#import "PDUtils.h"
#import "PDUserAPIService.h"
#import "PDAPIClient.h"
#import "PDUIInstagramLoginViewController.h"
#import "PDRewardAPIService.h"
#import "PDUIHomeViewController.h"
#import "PDUIRewardTableViewCell.h"
#import "PDUIDirectToSocialHomeHandler.h"
#import "PDCustomer.h"


@interface PDMultiLoginViewControllerV2 ()
@property (nonatomic, retain) PDMultiLoginViewModelV2* viewModel;
@property (nonatomic) BOOL facebookLoginOccurring;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) PDUIRewardTableViewCell *rewardCell;
@end

BOOL foundLocation = NO;

@implementation PDMultiLoginViewControllerV2

- (instancetype) initFromNibWithReward:(PDReward*)reward {
  NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
  if (self = [self initWithNibName:@"PDMultiLoginViewControllerV2" bundle:podBundle]) {
    self.view.backgroundColor = [UIColor whiteColor];
    self.reward = reward;
    return self;
  }
  return nil;
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
    

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
  //View Setup
  _viewModel = [[PDMultiLoginViewModelV2 alloc] initForViewController:self reward:_reward];
  [_viewModel setup];
    
    UIColor *customGrayColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.0].CGColor;
    UIColor *customColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.0];
  
  [_cancelButton setFont:PopdeemFont(PDThemeFontBold, 15)];
  [_cancelButton setTitleColor:customColor forState:UIControlStateNormal];

  [_titleLabel setText:_viewModel.titleString];
  [_titleLabel setFont:_viewModel.bodyFont];
  [_titleLabel setTextColor:customColor];
  [_titleLabel sizeToFit];
  
  [_bodyLabel setText:@""];
  [_bodyLabel setTextColor:customColor];
  [_bodyLabel setFont:_viewModel.bodyFont];
  
  if (![[PDCustomer sharedInstance] usesTwitter]) {
    [_twitterLoginButton setHidden:YES];
    [_twitterLoginButton setEnabled:NO];
    _twitterButtonHeightConstraint.constant = 0;
    _twitterButtonBottomGapLayoutConstraint.constant = 0;
  } else {
    [_twitterLoginButton setBackgroundColor:_viewModel.twitterButtonColor];
    [_twitterLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_twitterLoginButton.titleLabel setFont:PopdeemFont(PDThemeFontBold, 15)];
    [_twitterLoginButton setTitle:_viewModel.twitterButtonText forState:UIControlStateNormal];
    _twitterLoginButton.layer.cornerRadius = 25.0;
    _twitterLoginButton.clipsToBounds = YES;
      
      _twitterLoginButton.layer.masksToBounds = NO;
      _twitterLoginButton.layer.borderColor = (__bridge CGColorRef _Nullable)(UIColor.clearColor);
      _twitterLoginButton.layer.borderWidth = 1.0f;
      _twitterLoginButton.layer.shadowColor = _viewModel.twitterButtonColor.CGColor;
      _twitterLoginButton.layer.shadowOpacity = 0.5;
      _twitterLoginButton.layer.shadowRadius = 8;
      _twitterLoginButton.layer.shadowOffset = CGSizeMake(8.0f, 8.0f);
      
  }
    
    if (![[PDCustomer sharedInstance] usesInstagram]) {
        [_instagramLoginButton setHidden:YES];
        [_instagramLoginButton setEnabled:NO];
    } else {
  
    [_instagramLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _instagramLoginButton.layer.cornerRadius = 25.0;
    _instagramLoginButton.clipsToBounds = YES;
    [_instagramLoginButton setTitle:_viewModel.instagramButtonText forState:UIControlStateNormal];
    [_instagramLoginButton.titleLabel setFont:PopdeemFont(PDThemeFontBold, 15)];
    [_instagramLoginButton setBackgroundColor:_viewModel.instagramButtonColor];
  
    _instagramLoginButton.layer.masksToBounds = NO;
    _instagramLoginButton.layer.borderColor = (__bridge CGColorRef _Nullable)(UIColor.clearColor);
    _instagramLoginButton.layer.borderWidth = 1.0f;
    _instagramLoginButton.layer.shadowColor = _viewModel.instagramButtonColor.CGColor;
    _instagramLoginButton.layer.shadowOpacity = 0.5;
    _instagramLoginButton.layer.shadowRadius = 8;
    _instagramLoginButton.layer.shadowOffset = CGSizeMake(8.0f, 8.0f);
    }

    if(![[PDCustomer sharedInstance] usesFacebook]) {
        [_facebookLoginButton setHidden:YES];
        [_facebookLoginButton setEnabled:NO];
    } else {
    
      //Facebook setup
      _facebookLoginButton.layer.cornerRadius = 25.0;
      _facebookLoginButton.clipsToBounds = YES;
      [_facebookLoginButton setTitle:_viewModel.facebookButtonText forState:UIControlStateNormal];
      [self.facebookLoginButton.titleLabel setFont:PopdeemFont(PDThemeFontBold, 15)];
  
    _facebookLoginButton.layer.masksToBounds = NO;
    _facebookLoginButton.layer.borderColor = (__bridge CGColorRef _Nullable)(UIColor.clearColor);
    _facebookLoginButton.layer.borderWidth = 1.0f;
    _facebookLoginButton.layer.shadowColor = _viewModel.facebookButtonColor.CGColor;
    _facebookLoginButton.layer.shadowOpacity = 0.5;
    _facebookLoginButton.layer.shadowRadius = 8;
    _facebookLoginButton.layer.shadowOffset = CGSizeMake(8.0f, 8.0f);
        
    }
    
  if (_viewModel.image) {
    [self.imageView setImage:_viewModel.image];
  }
  [_imageView setContentMode:UIViewContentModeScaleAspectFill];
  _imageView.clipsToBounds = YES;
  
  //  [self.facebookLoginButton.imageView setImage:nil];
  for (NSLayoutConstraint *l in self.facebookLoginButton.constraints) {
    if ( l.constant == 28 ){
      // Then disable it...
      l.active = false;
      break;
    }
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelButtonPressed:) name:InstagramLoginuserDismissed object:nil];
  
  [_titleLabel setNumberOfLines:0];
}

- (void) viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) appWillEnterForeground:(id)sender {
  [self performSelector:@selector(dismissIfWaiting) withObject:nil afterDelay:5.0];
}

- (void) dismissIfWaiting {
  if (!_twitterValid) {
    if (_loadingView) {
      [_loadingView hideAnimated:YES];
    }
  }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)twitterLoginButtonPressed:(id)sender {
  _loadingView = [[PDUIModalLoadingView alloc] initWithDefaultsForView:self.view];
  _loadingView.titleLabel.text = @"Logging in.";
  [_loadingView showAnimated:YES];
  PDSocialMediaManager *manager = [[PDSocialMediaManager alloc] initForViewController:self];
  __weak __typeof(self) weakSelf = self;
  [manager registerWithTwitter:^{
    //Continue to next stage of app, login has happened.
    [self proceedWithTwitterLoggedInUser];
    weakSelf.twitterValid = YES;
  } failure:^(NSError *error) {
    weakSelf.twitterValid = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.loadingView hideAnimated:YES];
    });
    //Show some error, something went wrong
  }];
}

- (IBAction)instagramLoginButtonPressed:(id)sender {
  _loadingView = [[PDUIModalLoadingView alloc] initWithDefaultsForView:self.view];
  _loadingView.titleLabel.text = @"Logging in.";
  [_loadingView showAnimated:YES];
  PDUIInstagramLoginViewController *instaVC = [[PDUIInstagramLoginViewController alloc] initForParent:self delegate:self connectMode:NO directConnect:YES];
  instaVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
  instaVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [self presentViewController:instaVC animated:YES completion:^(void){}];
}

- (void) proceedWithTwitterLoggedInUser {
  [self addUserToUserDefaults:[PDUser sharedInstance]];
  AbraLogEvent(ABRA_EVENT_LOGIN, @{@"Source" : @"Login Takeover"});
  [self proceedWithLocationCheck];
}

- (void) addUserToUserDefaults:(PDUser*)user {
  [[NSUserDefaults standardUserDefaults] setObject:[user dictionaryRepresentation] forKey:@"popdeemUser"];
}

#pragma mark - Instagram Login Delegate Methods

- (void) connectInstagramAccount:(NSString*)identifier accessToken:(NSString*)accessToken userName:(NSString*)userName {
	PDUserAPIService *service = [[PDUserAPIService alloc] init];
    __weak typeof(self) weakSelf = self;
	[service registerUserWithInstagramId:identifier accessToken:accessToken fullName:@"" userName:userName profilePicture:@"" success:^(PDUser *user){
		[self addUserToUserDefaults:user];
		AbraLogEvent(ABRA_EVENT_LOGIN, @{@"Source" : @"Login Takeover"});
        dispatch_async(dispatch_get_main_queue(), ^{
            [self proceedWithLocationCheck];
        });
	} failure:^(NSError* error){
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.loadingView hideAnimated:YES];
    });
  }];
  
}
- (IBAction)cancelButtonPressed:(id)sender {
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [_loadingView hideAnimated:YES];
		});
	[weakSelf dismissAction:sender];
}

- (IBAction) dismissAction:(id)sender {
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [weakSelf.loadingView hideAnimated:YES];
  });
    
    NSString *socialLoginTransition = PopdeemSocialLoginTransition(PDThemeSocialLoginTransition);
    
    if ([socialLoginTransition isEqualToString:PDSocialLoginTransition2]) {
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
    
        [self dismissViewControllerAnimated:NO completion:^{
        //Any cleanup to do?
        [[NSNotificationCenter defaultCenter] postNotificationName:SocialLoginTakeoverDismissed object:self];
        }];
    } else {
      [self dismissViewControllerAnimated:NO completion:^{
        //Any cleanup to do?
        [[NSNotificationCenter defaultCenter] postNotificationName:SocialLoginTakeoverDismissed object:self];
      }];
     
    }
    
  AbraLogEvent(ABRA_EVENT_CLICKED_CLOSE_LOGIN_TAKEOVER, @{@"Source" : @"Dismiss Button"});
    
    
    
}

#pragma mark - Facebook Login -
- (IBAction) connectFacebook:(id)sender {
  self.facebookLoginOccurring = YES;
  _loadingView = [[PDUIModalLoadingView alloc] initWithDefaultsForView:self.view];
  _loadingView.titleLabel.text = @"Logging in.";
  [_loadingView showAnimated:YES];
  [[PDSocialMediaManager manager] loginWithFacebookReadPermissions:FACEBOOK_PERMISSIONS
                                               registerWithPopdeem:YES
                                                           success:^(void) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self facebookLoginSuccess];
                                                             });
                                                           } failure:^(NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self facebookLoginFailure];
                                                             });
                                                           }];
}

- (void) facebookLoginSuccess {
  AbraLogEvent(ABRA_EVENT_LOGIN, @{@"Source" : @"Login Takeover"});
  [self proceedWithLocationCheck];
}

- (void) facebookLoginFailure {
  dispatch_async(dispatch_get_main_queue(), ^{
    [_loadingView hideAnimated:YES];
  });
}

- (void) proceedWithLocationCheck {
  NSString *model = [[UIDevice currentDevice] model];
  if ([model isEqualToString:@"iPhone Simulator"]) {
    NSLog(@"SIMULATOR");
  }
  _locationManager = [[CLLocationManager alloc] init];
  [_locationManager requestWhenInUseAuthorization];
  _locationManager.distanceFilter = kCLDistanceFilterNone;
  _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  _locationManager.delegate = self;
  [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"Location Denied");
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [weakSelf.loadingView hideAnimated:YES];
  });
  [self dismissViewControllerAnimated:YES completion:^{
    [[NSNotificationCenter defaultCenter] postNotificationName:DirectToSocialHome object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:PDUserDidLogin
                                                        object:nil];
  }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
  NSLog(@"Location Updated");
    
    if (foundLocation) return;
    [_locationManager stopUpdatingLocation];
    foundLocation = YES;
    
  CLLocation *location = [locations lastObject];
  PDGeoLocation pdLoc = PDGeoLocationMake(location.coordinate.latitude, location.coordinate.longitude);
  [[PDUser sharedInstance] setLastLocation:pdLoc];
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service updateUserWithCompletion:^(PDUser *user, NSError *error) {
    PDLog(@"User Location Updated from Login");
  }];
  dispatch_async(dispatch_get_main_queue(), ^{
    [_loadingView hideAnimated:YES];
  });
  [self dismissViewControllerAnimated:YES completion:^{
      
    PDLog(@"NSNotification User Updated V2");
    [[NSNotificationCenter defaultCenter] postNotificationName:DirectToSocialHome object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:PDUserDidLogin
                                                        object:nil];
  }];
}

@end
