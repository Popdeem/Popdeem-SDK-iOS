//
//  PDSocialLoginViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDSocialLoginViewModel.h"
#import "PDSocialLoginViewController.h"
#import "PDSocialMediaManager.h"
#import "PDModalLoadingView.h"
#import "PDUser.h"
#import "PDAPIClient.h"
#import "PDConstants.h"
#import "PDMessageAPIService.h"
#import "PDTheme.h"


@interface PDSocialLoginViewModel()
@property (nonatomic, strong) PDModalLoadingView *loadingView;
@property (nonatomic) BOOL locationAcquired;
@property (nonatomic, strong) void (^locationBlock)(NSError *error);

@end
@interface PDSocialLoginViewModel() {
  PDModalLoadingView *loadingView;
  
  void (^locationBlock)(NSError *error);
  BOOL locationAcquired;
  
  CLLocationManager *manager;
}

@end

@implementation PDSocialLoginViewModel

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
  NSDictionary *dict = [NSUserDefaults standardUserDefaults];
  [self proceedWithLoggedInUser];
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
  //Should clear up Popdeem User
}

- (BOOL) checkPublishPermissions {
  return YES;
}

- (void) proceedWithLoggedInUser {
  self.loadingView = [[PDModalLoadingView alloc] initWithDefaultsForView:_viewController.view];
  [self.loadingView showAnimated:YES];
  

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
        if (error) {
          NSLog(@"Something went wrong: %@",error);
          [[PDSocialMediaManager manager] logoutFacebook];
          dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView hideAnimated:YES];
          });
          return;
        }
        
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
    //Cannot use the app without location
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
  self.image = PopdeemImage(@"popdeem.login.imageView.imageName");
  self.taglineString = translationForKey(@"popdeem.sociallogin.tagline", @"NEW: SOCIAL FEATURES.");
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
      self.taglineString = translationForKey(@"popdeem.sociallogin.tagline", @"NEW: SOCIAL FEATURES.");
      self.headingString = translationForKey(@"popdeem.sociallogin.heading", @"Connect your Facebook to earn additional Rewards.");
      self.bodyString = translationForKey(@"popdeem.sociallogin.body", @"Connect your Facebook account to turn social features on. This will give you access to exclusive content and new social rewards.");
      self.termsLabelString = translationForKey(@"popdeem.sociallogin.terms", @"By signing in with Facebook you accept the terms of our privacy policy.");
      self.loginState = LoginStateLogin;
      break;
  }
}

@end
