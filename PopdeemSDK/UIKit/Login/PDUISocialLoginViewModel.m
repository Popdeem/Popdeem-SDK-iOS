//
//  PDSocialLoginViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDUISocialLoginViewModel.h"
#import "PDUISocialLoginViewController.h"
#import "PDSocialMediaManager.h"
#import "PDUIModalLoadingView.h"
#import "PDUser.h"
#import "PDAPIClient.h"
#import "PDConstants.h"
#import "PDMessageAPIService.h"
#import "PDTheme.h"


@interface PDUISocialLoginViewModel()
@property (nonatomic, strong) PDUIModalLoadingView *loadingView;
@property (nonatomic) BOOL locationAcquired;
@property (nonatomic, strong) void (^locationBlock)(NSError *error);

@end
@interface PDUISocialLoginViewModel() {

  
  CLLocationManager *manager;
}

@end

@implementation PDUISocialLoginViewModel

- (instancetype) init {
  if (self = [super init]) {
    [self setState:LoginStateLogin];
    return self;
  }
  return nil;
}

- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
  //Perform Popdeem User Login
  if (error) {
    //Show error message
    return;
  }
  
  if (result.isCancelled) {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.facebookLoginCancelledTitle",@"Login Cancelled.")
                                                 message:translationForKey(@"popdeem.common.facebookLoginCancelledBody",@"You must log in with Facebook to avail of social rewards.")
                                                delegate:self.viewController
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles: nil];
    [av show];
    return;
  }
  
  NSUserDefaults *dict = [NSUserDefaults standardUserDefaults];
  [self proceedWithLoggedInUser];
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
  //Should clear up Popdeem User
}



- (BOOL) checkPublishPermissions {
  return YES;
}

- (void) proceedWithLoggedInUser {
  self.loadingView = [[PDUIModalLoadingView alloc] initWithDefaultsForView:_viewController.view];
  [self.loadingView showAnimated:YES];
	[[PDUser sharedInstance] refreshFacebookFriendsCallback:^(BOOL response){
		NSLog(@"Facebook Friends Updated");
	}];
  [[PDSocialMediaManager manager] nextStepForFacebookLoggedInUser:^(NSError *error) {
    if (error) {
      NSLog(@"Something went wrong: %@",error);
      [[PDSocialMediaManager manager] logoutFacebook];
      dispatch_async(dispatch_get_main_queue(), ^{
        [_loadingView hideAnimated:YES];
      });
      return;
    }
    
    if (_viewController.shouldAskLocation) {
      [self fetchLocationCompletion:^(NSError *error){
//        if (error) {
//          NSLog(@"Something went wrong: %@",error);
//          [[PDSocialMediaManager manager] logoutFacebook];
//          dispatch_async(dispatch_get_main_queue(), ^{
//            [self.loadingView hideAnimated:YES];
//          });
//          return;
//        }
				
        [self renderSuccess];
      }];
    } else {
      [self renderSuccess];
    }
  }];
}

- (BOOL) loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
  _viewController.facebookLoginOccurring = YES;
  return YES;
}

- (void) renderSuccess {
  dispatch_async(dispatch_get_main_queue(), ^{
    [_loadingView hideAnimated:YES];
  });
  [self addUserToUserDefaults:[PDUser sharedInstance]];
  [self setState:LoginStateContinue];
  [self.viewController renderViewModelState];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"PopdeemUserLoggedInNotification" object:nil];
}

#pragma mark - Fetch Location -

- (void) fetchLocationCompletion:(void (^)(NSError *error))completion {
  
  self.locationBlock = completion;
  if ([PDGeolocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
      [[PDGeolocationManager sharedInstance] requestWhenInUseAuthorization];
    }
  } else if ([PDGeolocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    [[PDGeolocationManager sharedInstance] stopUpdatingLocation];
    NSLog(@"The user did not allow their location");
    NSError *locationError = [NSError errorWithDomain:@"Popdeem Location Error" code:27000 userInfo:@{@"User did not allow location":NSLocalizedDescriptionKey}];
    self.locationBlock(locationError);
    return;
    dispatch_async(dispatch_get_main_queue(), ^{
      [self checkLocation];
    });
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    [self checkLocation];
  });
}

- (void) checkLocation {
#if (TARGET_IPHONE_SIMULATOR)
  if (self.locationAcquired == NO) {
    [[PDGeolocationManager sharedInstance] stopUpdatingLocation];
    self.locationAcquired = YES;
  } else {
    return;
  }
  
  float latitude = 53.3356002f;
  float longitude = -6.2674742;
  
  [[PDUser sharedInstance] setLastLocation:PDGeoLocationMake(latitude, longitude)];
  
  [self updateUserLocationCompletion:^(NSError *error){
    self.locationBlock(error);
  }];
  return;
#else
  [[PDGeolocationManager sharedInstance] updateLocationWithDelegate:self distanceFilter:kCLDistanceFilterNone accuracy:kCLLocationAccuracyNearestTenMeters];
#endif
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if (error.code == kCLErrorDenied) {
		NSLog(@"User Denied Location");
		[[PDGeolocationManager sharedInstance] stopUpdatingLocation];
		_locationAcquired = YES;
		self.locationBlock(error);
	}
  if (_locationAcquired == NO) {
    NSLog(@"Error: %@",error);
    [[PDGeolocationManager sharedInstance] stopUpdatingLocation];
    [self performSelector:@selector(checkLocation) withObject:nil afterDelay:0.1];
  }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
  NSLog(@"did update location");
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
  if (self.locationAcquired == NO) {
    [[PDGeolocationManager sharedInstance] stopUpdatingLocation];
    self.locationAcquired = YES;
  } else {
    return;
  }
  
  CLLocation *location = [locations lastObject];
  if (!location) {
    return;
  }
  float latitude = location.coordinate.latitude;
  float longitude = location.coordinate.longitude;
  
  [[PDUser sharedInstance] setLastLocation:PDGeoLocationMake(latitude, longitude)];
  
  [self updateUserLocationCompletion:^(NSError *error){
    self.locationBlock(error);
  }];
}

- (void) updateUserLocationCompletion:(void (^)(NSError *error))completion {
  [[PDAPIClient sharedInstance] updateUserLocationAndDeviceTokenSuccess:^(PDUser *user) {
    NSLog(@"User Updated OK");
    self.locationBlock(nil);
  }failure:^(NSError *error) {
    self.locationBlock(error);
  }];
}

- (void) setState:(LoginState)state {
  self.bodyString = translationForKey(@"popdeem.sociallogin.body", @"Connect your Facebook account to turn social features on. This will give you access to exclusive content and new social rewards.");
  self.image = PopdeemImage(@"popdeem.images.loginImage");
  self.taglineString = translationForKey(@"popdeem.sociallogin.tagline", @"New: Social Rewards.");
  self.headingString = translationForKey(@"popdeem.sociallogin.heading", @"Connect your Facebook to earn additional Rewards.");
  self.bodyString = translationForKey(@"popdeem.sociallogin.body", @"Connect your Facebook account to turn social features on. This will give you access to exclusive content and new social rewards.");
  self.termsLabelString = translationForKey(@"popdeem.sociallogin.terms", @"By signing in with Facebook you accept the terms of our privacy policy.");
  
  switch (state) {
    case LoginStateContinue:
      self.headingString = translationForKey(@"popdeem.sociallogin.success", @"Connected!");
      self.bodyString = translationForKey(@"popdeem.sociallogin.success.description", @"Rewards are now unlocked. You will be notified when new rewards are available!");
      self.loginState = LoginStateContinue;
      break;
    case LoginStateLogin:
    default:
      self.taglineString = translationForKey(@"popdeem.sociallogin.tagline", @"New: Social Rewards.");
      self.headingString = translationForKey(@"popdeem.sociallogin.heading", @"Connect your Facebook to earn additional Rewards.");
      self.bodyString = translationForKey(@"popdeem.sociallogin.body", @"Connect your Facebook account to turn social features on. This will give you access to exclusive content and new social rewards.");
      self.termsLabelString = translationForKey(@"popdeem.sociallogin.terms", @"By signing in with Facebook you accept the terms of our privacy policy.");
      self.loginState = LoginStateLogin;
      break;
  }
}

- (void) addUserToUserDefaults:(PDUser*)user {
  [[NSUserDefaults standardUserDefaults] setObject:[user dictionaryRepresentation] forKey:@"popdeemUser"];
}

@end
