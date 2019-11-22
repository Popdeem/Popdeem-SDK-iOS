//
//  PopdeemSDK.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "PopdeemSDK.h"
#import "PDSocialMediaManager.h"
#import "PDNotificationHandler.h"
#import "PDMessageAPIService.h"
#import "PDUserAPIService.h"
#import "PDBrandApiService.h"
#import "PDReferral.h"
#import "PDMomentsManager.h"
#import "PDAPIClient.h"
#import "PDMessageStore.h"
#import <UserNotifications/UserNotifications.h>
#import "PDRealm.h"
#import "PDCustomerAPIService.h"
#import "PDStringsHelper.h"
#import "PDCustomer.h"
#import "TWTRKit.h"
#import "PDSocialAPIService.h"
#import "PDAPIClient.h"

@interface PopdeemSDK()
  @property (nonatomic, strong)id uiKitCore;
@property (nonatomic) BOOL locationFetched;
@end
@implementation PopdeemSDK

+ (id) sharedInstance {
  static PopdeemSDK *SDK;
  static dispatch_once_t sharedToken;
  dispatch_once(&sharedToken, ^{
    SDK = [[PopdeemSDK alloc] init];
		if (SDK) {
			[SDK setDebug:NO];
      [SDK setEnv:PDEnvProduction];
		}
  });
  return SDK;
}

- (void) fetchCustomer {
  PDCustomerAPIService *service = [[PDCustomerAPIService alloc] init];
  [service getCustomerWithCompletion:^(NSError *error) {
    PDLog(@"Fetched Customer");
  }];
}


- (id) init {
  if (self = [super init]) {
    return self;
  }
  return nil;
}

+ (void) setEnv:(PDEnv)env {
  PopdeemSDK *SDK = [PopdeemSDK sharedInstance];
  [SDK setEnv:env];
}
  
- (NSString*) apiURL {
  PopdeemSDK *SDK = [PopdeemSDK sharedInstance];
  if (SDK) {
    switch ([SDK env]) {
      case PDEnvProduction:
        return @"https://api.popdeem.com";
      break;
      case PDEnvStaging:
        return @"https://api-staging.popdeem.com";
      break;
      default:
        return @"https://api.popdeem.com";
      break;
    }
  }
  return @"https://api.popdeem.com";
}

+ (void) setDebug:(BOOL)debug {
	PopdeemSDK *sdk = [PopdeemSDK sharedInstance];
	sdk.debug = debug;
}

+ (BOOL) debugMode {
	return [[PopdeemSDK sharedInstance] debug];
}

+ (void) startupBrands {
    PDBrandApiService *service = [[PDBrandApiService alloc] init];
    [service getBrandsWithCompletion:^(NSError *error) {
        if (error) {
            PDLogError(@"Error Fetching Brands: %@", error.localizedDescription);
				} else {
					[[NSNotificationCenter defaultCenter] postNotificationName:DidFetchBrands object:nil];
				}
    }];
}

+ (void) withAPIKey:(NSString*)apiKey env:(PDEnv)env {
  PopdeemSDK *SDK = [[self class] sharedInstance];
  [SDK setEnv:env];
  [SDK setApiKey:apiKey];
  [SDK nonSocialRegister];
  [PDRealm initRealmDB];
  PDCustomerAPIService *service = [[PDCustomerAPIService alloc] init];
  [service getCustomerWithCompletion:^(NSError *error) {
    PDLog(@"Fetched Customer");
    if ([[PDCustomer sharedInstance] twitterConsumerKey] && [[PDCustomer sharedInstance] twitterConsumerSecret]) {
      [[Twitter sharedInstance] startWithConsumerKey:[[PDCustomer sharedInstance] twitterConsumerKey] consumerSecret:[[PDCustomer sharedInstance] twitterConsumerSecret]];
    }
  }];
}

+ (void) withAPIKey:(NSString*)apiKey {
  [PopdeemSDK withAPIKey:apiKey env:PDEnvProduction];
}

+ (void) testingWithAPIKey:(NSString*)apiKey {
  PopdeemSDK *SDK = [[self class] sharedInstance];
  [SDK setApiKey:apiKey];
}

+ (void) enableSocialLoginWithNumberOfPrompts:(NSInteger) noOfPrompts {
  id uiKitCore = [[self sharedInstance]popdeemUIKitCore];
  SEL selector = NSSelectorFromString(@"enableSocialLoginWithNumberOfPrompts:");
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [uiKitCore performSelector:selector withObject:[NSNumber numberWithInteger:noOfPrompts]];
#pragma clang diagnostic pop
}

+ (void) setUpThemeFile:(NSString*)themeName {
  id uiKitCore = [[self sharedInstance]popdeemUIKitCore];
  SEL selector = NSSelectorFromString(@"setThemeFile:");
  
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [uiKitCore performSelector:selector withObject:themeName];
#pragma clang diagnostic pop
  PDStringsHelper *helper = [[PDStringsHelper alloc] init];
  [helper countGratitudeVariations];
}

+ (void) presentRewardFlow {
  id uiKitCore = [[self sharedInstance]popdeemUIKitCore];
  SEL selector = NSSelectorFromString(@"presentRewardFlow");
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [uiKitCore performSelector:selector];
#pragma clang diagnostic pop
}

+ (void) directToSocialHome {
  id uiKitCore = [[self sharedInstance] popdeemUIKitCore];
  SEL selector = NSSelectorFromString(@"directToSocialHome");
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [uiKitCore performSelector:selector];
#pragma clang diagnostic pop
}

+ (void) presentHomeFlowInNavigationController:(UINavigationController*)navController {
  id uiKitCore = [[self sharedInstance]popdeemUIKitCore];
  SEL selector = NSSelectorFromString(@"presentHomeFlowInNavigationController:");
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [uiKitCore performSelector:selector withObject:navController];
#pragma clang diagnostic pop
}

+ (void) presentBrandFlowInNavigationController:(UINavigationController*)navController {
	id uiKitCore = [[self sharedInstance]popdeemUIKitCore];
	SEL selector = NSSelectorFromString(@"presentBrandFlowInNavigationController:");
	
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	[uiKitCore performSelector:selector withObject:navController];
#pragma clang diagnostic pop
}

+ (void) presentRewardsForBrand:(PDBrand*)b inNavigationController:(UINavigationController*)navController {
    id uiKitCore = [[self sharedInstance]popdeemUIKitCore];
    SEL selector = NSSelectorFromString(@"presentRewardsForBrand:inNavigationController:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [uiKitCore performSelector:selector withObject:b withObject:navController];
#pragma clang diagnostic pop
}

+ (void) pushRewardsToNavigationController:(UINavigationController*)navController animated:(BOOL)animated {
  id uiKitCore = [[self sharedInstance]popdeemUIKitCore];
  SEL selector = NSSelectorFromString(@"pushRewardsToNavigationController:animated");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [uiKitCore performSelector:selector];
#pragma clang diagnostic pop
}

- (id)popdeemUIKitCore {
  if(self.uiKitCore) return self.uiKitCore;
  Class coreClazz = NSClassFromString(@"PopdeemUIKItCore");
  
  if(!coreClazz){
    [NSException raise:@"Popdeem UIKit not installed - pod 'PopdeemSDK/UIKit'" format:@""];
  }
  
  self.uiKitCore =  [[coreClazz alloc]init];
  
  return self.uiKitCore;
}


+ (void) registerForPushNotificationsApplication:(UIApplication *)application {
  [[PDNotificationHandler sharedInstance] registerForPushNotificationsApplication:application];
}

+ (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [[PDNotificationHandler sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
  [[PopdeemSDK sharedInstance] nonSocialRegister];
}

+ (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  [[PDNotificationHandler sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

+ (void) handleRemoteNotification:(NSDictionary*)userInfo {
  [[PDNotificationHandler sharedInstance] showRemoteNotification:userInfo completion:^(BOOL success) {
    PDLog(@"Notification Shown");
  }];
  [[NSNotificationCenter defaultCenter] postNotificationName:PopdeemNotificationReceived object:nil];
}

+ (BOOL) canOpenUrl:(NSURL*)url	
  sourceApplication:(NSString *)sourceApplication
         annotation:(nullable id)annotation {

  return [PopdeemSDK application:[UIApplication sharedApplication] canOpenUrl:url options:@{}];
}

+ (BOOL) application:(UIApplication*)application canOpenUrl:(NSURL *)url options:(NSDictionary*)options {
  if ([[url scheme] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"TwitterCallbackScheme"]]) {
    return YES;
  }
  if ([[url scheme] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"FacebookNamespace"]]) {
    return YES;
  }
  if ([[url scheme] rangeOfString:@"twitterkit"].location != NSNotFound) {
    return YES;
  }
  for (NSString *scheme in [[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"] firstObject] objectForKey:@"CFBundleURLSchemes"]) {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^fb"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:scheme
                                                        options:0
                                                          range:NSMakeRange(0, [scheme length])];
    if (numberOfMatches > 0) {
      return YES;
    }
  }
  return NO;
}

/*
+ (BOOL) application:(UIApplication*)application openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
  BOOL twitterHandled = [[Twitter sharedInstance] application:application openURL:url options:options];
  if (twitterHandled) {
    return twitterHandled;
  }
 */

+ (BOOL) application:(UIApplication*)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    BOOL twitterHandled = [[Twitter sharedInstance] application:application openURL:url options:options];
    if (twitterHandled) {
        return twitterHandled;
    }
  
  if ([[url scheme] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"FacebookNamespace"]]) {
    return [PopdeemSDK processReferral:application url:url sourceApplication:@"" annotation:nil];
  }

  for (NSString *scheme in [[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"] firstObject] objectForKey:@"CFBundleURLSchemes"]) {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^fb"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:scheme
                                                        options:0
                                                          range:NSMakeRange(0, [scheme length])];
    if (numberOfMatches > 0) {
      return [PopdeemSDK processReferral:application url:url sourceApplication:@"" annotation:nil];
    }
  }
  return YES;
}

+ (BOOL) application:(UIApplication *)application
             openURL:(NSURL *)url
   sourceApplication:(NSString *)sourceApplication
          annotation:(nullable id)annotation {
  
  //Facebook Deep Linking Handling
  if ([[url scheme] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"FacebookNamespace"]]) {
    return [PopdeemSDK processReferral:application url:url sourceApplication:@"" annotation:nil];
  }
  for (NSString *scheme in [[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"] firstObject] objectForKey:@"CFBundleURLSchemes"]) {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^fb"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:scheme
                                                        options:0
                                                          range:NSMakeRange(0, [scheme length])];
    if (numberOfMatches > 0) {
      return [PopdeemSDK processReferral:application url:url sourceApplication:@"" annotation:nil];
    }
  }
  return YES;
}


+ (BOOL) processReferral:(UIApplication *)application
                     url:(NSURL *)url
       sourceApplication:(NSString *)sourceApplication
              annotation:(id)annotation {
  PDReferral *r = [[PDReferral alloc] initWithUrl:url appRef:sourceApplication];
  [PDReferral logReferral:r];
  return YES;
}

+ (NSDictionary *) parametersDictionaryFromQueryString:(NSString *)queryString {
  
  NSMutableDictionary *md = [NSMutableDictionary dictionary];
  
  NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
  
  for(NSString *s in queryComponents) {
    NSArray *pair = [s componentsSeparatedByString:@"="];
    if([pair count] != 2) continue;
    
    NSString *key = pair[0];
    NSString *value = pair[1];
    
    md[key] = value;
  }
  
  return md;
}

- (void) nonSocialRegister {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"popdeemUser"] == nil &&
			[[NSUserDefaults standardUserDefaults] objectForKey:@"PopdeemNonSocialRegistered"] == nil) {
    PDLog(@"Sending Non Social User details");
    PDUserAPIService *service = [[PDUserAPIService alloc] init];
    [service nonSocialUserInitWithCompletion:^(NSError *error){
      if (!error) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"PopdeemNonSocialRegistered"];
      } else {
        PDLogError(@"Error registering non-social user: %@",error.localizedDescription);
      }
    }];
  } else {
      [PDUser initFromUserDefaults:[[NSUserDefaults standardUserDefaults] objectForKey:@"popdeemUser"]];
      if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
          [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
          _locationManager = [[CLLocationManager alloc] init];
          _locationManager.delegate = self;
          [_locationManager requestWhenInUseAuthorization];
          _locationManager.distanceFilter = kCLDistanceFilterNone;
          _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
          [_locationManager startUpdatingLocation];
      }
  }
}

+ (void) logMoment:(NSString*)momentString {
  [PDMomentsManager logMoment:momentString];
}

+ (void) setThirdPartyUserToken:(NSString*)userToken {
    if (userToken.length == 0) {return ;}
  [[PDAPIClient sharedInstance] setThirdPartyToken:userToken];
  if (![[PDUser sharedInstance] identifier]) {
    return;
  }
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service updateUserWithCompletion:^(PDUser *user, NSError *error){
    if (error) {
      PDLogError(@"Error updating User: %@", error.localizedDescription);
    }
  }];
}




+ (void) setFacebookCredentials:(NSString*)facebookAccessToken
                     facebookId:(NSString*)facebookId {
    
    
    if (facebookAccessToken.length == 0) {return ;}
    [[PDAPIClient sharedInstance] setFacebookAccessToken:facebookAccessToken];
    [[PDAPIClient sharedInstance] setFacebookID:facebookId];
    
    // Register with Facebook & Log into Social
    
    PDUserAPIService *service = [[PDUserAPIService alloc] init];
    [service registerUserwithFacebookAccesstoken:facebookAccessToken facebookId:facebookId completion:^(PDUser *user, NSError *error) {
        if (error) {
            PDLogError(@"Error updating User: %@", error.localizedDescription);
        }
    }];
    
}




+ (void) logout {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"popdeemUser"]) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"popdeemUser"];
	}
	[PDUser resetSharedInstance];
	[[PDMessageStore store] removeAllObjects];
	[[PDSocialMediaManager manager] logoutFacebook];
	[[NSNotificationCenter defaultCenter] postNotificationName:PDUserDidLogout object:nil];
}

#pragma mark - Instagram - 

+ (NSString*) instagramClientId {
	NSString *clientId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"InstagramClientId"];
	if (!clientId) {
		[NSException raise:@"No Instagram Client ID found. Please add your Instagram Client ID in info.plist under the key 'InstagramClientID'" format:@""];
	}
	return clientId;
}

+ (NSString*) instagramClientSecret {
	NSString *clientSecret = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"InstagramClientSecret"];
	if (!clientSecret) {
		[NSException raise:@"No Instagram Client Secret found. Please add your Instagram Client ID in info.plist under the key 'InstagramClientSecret'" format:@""];
	}
	return clientSecret;
}

+ (NSString*) instagramCallback {
	NSString *instagramCallback = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"InstagramCallback"];
	if (!instagramCallback) {
		[NSException raise:@"No Instagram Callback. Please add your Instagram Client ID in info.plist under the key 'InstagramCallback'" format:@""];
	}
	return instagramCallback;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (_locationFetched) { return; }
    _locationFetched = YES;
    [_locationManager stopUpdatingLocation];
    CLLocation *loc = [locations lastObject];
    PDGeoLocation pdLoc = PDGeoLocationMake(loc.coordinate.latitude, loc.coordinate.longitude);
    PDUserAPIService *userService = [[PDUserAPIService alloc] init];
    [[PDUser sharedInstance] setLastLocation:pdLoc];
    [userService updateUserWithCompletion:^(PDUser *user, NSError *error) {
        PDLog(@"User Updated Location after app launch to: %.2f, %.2f", pdLoc.latitude, pdLoc.longitude);
    }];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    PDLog(@"Cannot Fetch Location On App Launch");
    [_locationManager stopUpdatingLocation];
}

@end
