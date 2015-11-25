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

@interface PDSocialLoginViewModel() {
    PDModalLoadingView *loadingView;
    
    void (^locationBlock)(NSError *error);
    BOOL locationAcquired;
    
    CLLocationManager *manager;
}

@end
@implementation PDSocialLoginViewModel

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


- (void) showPublishFlowIfNeeded {
    BOOL publish = [self checkPublishPermissions];
    if (publish) {
        [_viewController dismissViewControllerAnimated:YES completion:^{}];
    } else {
        
    }
}

- (BOOL) checkPublishPermissions {
    return YES;
}

- (void) proceedWithLoggedInUser {
    loadingView = [[PDModalLoadingView alloc] initWithDefaultsForView:_viewController.containterView];
    [loadingView showAnimated:YES];
    
    PDSocialMediaManager *man = [[PDSocialMediaManager alloc] init];
    [man nextStepForFacebookLoggedInUser:^(NSError *error) {
        if (error) {
            NSLog(@"Something went wrong: %@",error);
//            [[PDSocialMediaManager manager] logoutFacebook];
            return;
        }

        if (_viewController.shouldAskLocation) {
            [self fetchLocationCompletion:^(NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [loadingView hideAnimated:YES];
                });
                if (error) {
                    NSLog(@"Something went wrong with Location: %@",error);
                }
            }];
            [self renderSuccess];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingView hideAnimated:YES];
            });
            [self renderSuccess];
        }
    }];
}

- (BOOL) loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
    _viewController.facebookLoginOccurring = YES;
    return YES;
}

- (void) renderSuccess {
    _viewController.titleLabel.text = @"Connected!";
    _viewController.titleLabel.textColor = [UIColor colorWithRed:0.184 green:0.553 blue:0.000 alpha:1.000];
    _viewController.iconView.image = [UIImage imageNamed:@"pduikit_rewardsIconSuccess"];
    [_viewController.descriptionLabel setText:@"Rewards are now unlocked. You will be notified when new rewards are available!"];
    [_viewController.loginButton setHidden:YES];
    [_viewController.continueButton setHidden:NO];
    [_viewController.view setNeedsDisplay];
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
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Location not Authorized"
                                                     message:@"You have not authorized the app to use your location. Sober Lane is a location based app, please go to your settings and allow location."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av setTag:0];
        [av show];
        return;
    }
    [self checkLocation];
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

@end
