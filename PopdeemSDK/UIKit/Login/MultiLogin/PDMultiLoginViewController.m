//
//  PDMultiLoginViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/01/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import "PDMultiLoginViewController.h"
#import "PDSocialMediaManager.h"
#import "PDMultiLoginViewModel.h"
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

@interface PDMultiLoginViewController ()
@property (nonatomic, retain) PDMultiLoginViewModel* viewModel;
@property (nonatomic) BOOL facebookLoginOccurring;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) PDUIRewardTableViewCell *rewardCell;
@property (nonatomic) BOOL twitterValid;
@end

@implementation PDMultiLoginViewController

- (instancetype) initFromNibWithReward:(PDReward*)reward {
  NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
  if (self = [self initWithNibName:@"PDMultiLoginViewController" bundle:podBundle]) {
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
	_viewModel = [[PDMultiLoginViewModel alloc] initForViewController:self reward:_reward];
	[_viewModel setup];
	
	[_titleLabel setText:_viewModel.titleString];
	[_titleLabel setFont:_viewModel.titleFont];
	[_titleLabel setTextColor:_viewModel.titleColor];
  [_titleLabel sizeToFit];
	
	[_bodyLabel setText:_viewModel.bodyString];
	[_bodyLabel setTextColor:_viewModel.bodyColor];
	[_bodyLabel setFont:_viewModel.bodyFont];
	
  if (![[PDCustomer sharedInstance] usesTwitter]) {
    [_twitterLoginButton setHidden:YES];
    [_twitterLoginButton setEnabled:NO];
    _twitterButtonHeightConstraint.constant = 0;
    _twitterButtonBottomGapLayoutConstraint.constant = 0;
  } else {
    [_twitterLoginButton setBackgroundColor:_viewModel.twitterButtonColor];
    [_twitterLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_twitterLoginButton.titleLabel setFont:PopdeemFont(PDThemeFontPrimary, 15)];
    _twitterLoginButton.layer.cornerRadius = 5.0;
    _twitterLoginButton.clipsToBounds = YES;
  }
	
	[_instagramLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  _instagramLoginButton.layer.cornerRadius = 5.0;
  _instagramLoginButton.clipsToBounds = YES;
  [_instagramLoginButton.titleLabel setFont:PopdeemFont(PDThemeFontPrimary, 15)];
  [_instagramLoginButton setBackgroundColor:_viewModel.instagramButtonColor];
	
	//Facebook setup
  _facebookLoginButton.layer.cornerRadius = 5.0;
  _facebookLoginButton.clipsToBounds = YES;
  [_facebookLoginButton setTitle:_viewModel.facebookButtonText forState:UIControlStateNormal];
  [self.facebookLoginButton.titleLabel setFont:_viewModel.facebookButtonFont];
  
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
//  //TESTING
//  _loadingView = [[PDUIModalLoadingView alloc] initWithDefaultsForView:self.view];
//  _loadingView.titleLabel.text = @"Logging in.";
//  [_loadingView showAnimated:YES];
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
	[self dismissViewControllerAnimated:YES completion:^{
		//Any cleanup to do?
	}];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:DirectToSocialHome object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:PDUserDidLogin
                                                            object:nil];
    }];
}

@end
