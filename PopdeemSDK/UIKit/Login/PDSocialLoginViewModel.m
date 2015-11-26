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

@interface PDSocialLoginViewModel() {
  PDModalLoadingView *loadingView;
  
  void (^locationBlock)(NSError *error);
  BOOL locationAcquired;
  
  CLLocationManager *manager;
}

@end
@implementation PDSocialLoginViewModel

- (id) init {
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
  [self proceedWithLoggedInUser];
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
  //Should clear up Popdeem User
}

- (BOOL) checkPublishPermissions {
  return YES;
}

- (void) proceedWithLoggedInUser {
  loadingView = [[PDModalLoadingView alloc] initWithDefaultsForView:_viewController.containterView];
  [loadingView showAnimated:YES];
  
  [[PDSocialMediaManager manager] nextStepForFacebookLoggedInUser:^(NSError *error) {
    if (error) {
      NSLog(@"Something went wrong: %@",error);
      [[PDSocialMediaManager manager] logoutFacebook];
      dispatch_async(dispatch_get_main_queue(), ^{
        [loadingView hideAnimated:YES];
      });
      return;
    }
    
    if (_viewController.shouldAskLocation) {
      [self fetchLocationCompletion:^(NSError *error){
        if (error) {
          NSLog(@"Something went wrong with Location: %@",error);
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
    [loadingView hideAnimated:YES];
  });
  
  [self setState:LoginStateContinue];
  [self.viewController renderViewModelState];
}

#pragma mark - Fetch Location -

- (void) fetchLocationCompletion:(void (^)(NSError *error))completion {
  locationBlock = completion;
  if ([PDGeolocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
      [[PDGeolocationManager sharedInstance] requestWhenInUseAuthorization];
    }
  } else if ([PDGeolocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    //Cannot use the app without location
    [[PDGeolocationManager sharedInstance] stopUpdatingLocation];
    NSLog(@"The user did not allow their location");
    NSError *locationError = [NSError errorWithDomain:@"Popdeem Location Error" code:27000 userInfo:@{@"User did not allow location":NSLocalizedDescriptionKey}];
    locationBlock(locationError);
    return;
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    [self checkLocation];
  });
}

- (void) checkLocation {
  [[PDGeolocationManager sharedInstance] updateLocationWithDelegate:self distanceFilter:kCLDistanceFilterNone accuracy:kCLLocationAccuracyNearestTenMeters];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  if (locationAcquired == NO) {
    NSLog(@"Error: %@",error);
    [[PDGeolocationManager sharedInstance] stopUpdatingLocation];
    [self performSelector:@selector(checkLocation) withObject:nil afterDelay:0.1];
  }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
  NSLog(@"did update location");
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
  if (locationAcquired == NO) {
    [[PDGeolocationManager sharedInstance] stopUpdatingLocation];
    locationAcquired = YES;
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
  
  [[PDAPIClient sharedInstance] updateUserLocationAndDeviceTokenSuccess:^(PDUser *user) {
    NSLog(@"User Updated OK");
    locationBlock(nil);
  }failure:^(NSError *error) {
    locationBlock(error);
  }];
}

- (void) setState:(LoginState)state {
  self.subTitleLabelString = translationForKey(@"popdeem.sociallogin.subtitle", @"Rewards Available");
  self.iconImageName = @"pduikit_rewardsIcon";
  self.descriptionLabelString = translationForKey(@"popdeem.sociallogin.description", @"To see what rewards you have unlocked, simply connect your Facebook account below.");
  
  
  switch (state) {
    case LoginStateContinue:
      self.titleLabelString = translationForKey(@"popdeem.sociallogin.success", @"Connected!");
      self.iconImageName = @"pduikit_rewardsIconSuccess";
      self.descriptionLabelString = translationForKey(@"popdeem.sociallogin.success.description", @"Rewards are now unlocked. You will be notified when new rewards are available!");
      self.loginState = LoginStateContinue;
      break;
    case LoginStateLogin:
    default:
      self.titleLabelString = translationForKey(@"popdeem.sociallogin.title", @"App Update");
      self.iconImageName = @"pduikit_rewardsIcon";
      self.descriptionLabelString = NSLocalizedString(@"popdeem.sociallogin.description", nil);
      self.descriptionLabelString = @"To see what rewards you have unlocked, simply connect your Facebook account below.";
      self.loginState = LoginStateLogin;
      break;
  }
}

@end
