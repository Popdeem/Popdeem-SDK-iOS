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
#import "PDReferral.h"
#import "PDMomentsManager.h"
#import "PDAPIClient.h"
#import "PDMessageStore.h"

@interface PopdeemSDK()
@property (nonatomic, strong)id uiKitCore;
@end
@implementation PopdeemSDK

+ (id) sharedInstance {
  static PopdeemSDK *SDK;
  static dispatch_once_t sharedToken;
  dispatch_once(&sharedToken, ^{
    SDK = [[PopdeemSDK alloc] init];
    
  });
  return SDK;
}

+ (void) withAPIKey:(NSString*)apiKey {
  PopdeemSDK *SDK = [[self class] sharedInstance];
  [SDK setApiKey:apiKey];
  [SDK nonSocialRegister];
}

+ (void) testingWithAPIKey:(NSString*)apiKey {
  PopdeemSDK *SDK = [[self class] sharedInstance];
  [SDK setApiKey:apiKey];
}

+ (void) setTwitterOAuthToken:(NSString*)token verifier:(NSString*) verifier {
  [[PDSocialMediaManager manager] setOAuthToken:token oauthVerifier:verifier];
}

+ (void) enableSocialLoginWithNumberOfPrompts:(NSInteger) noOfPrompts {
  id uiKitCore = [[self sharedInstance]popdeemUIKitCore];
  SEL selector = NSSelectorFromString(@"enableSocialLoginWithNumberOfPrompts:");
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [uiKitCore performSelector:selector withObject:[NSNumber numberWithInt:noOfPrompts]];
#pragma clang diagnostic pop
}

+ (void) setUpThemeFile:(NSString*)themeName {
  id uiKitCore = [[self sharedInstance]popdeemUIKitCore];
  SEL selector = NSSelectorFromString(@"setThemeFile:");
  
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [uiKitCore performSelector:selector withObject:themeName];
#pragma clang diagnostic pop
}

+ (void) presentRewardFlow {
  id uiKitCore = [[self sharedInstance]popdeemUIKitCore];
  SEL selector = NSSelectorFromString(@"presentRewardFlow");
  
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
  if (NSClassFromString(@"PopdeemUIKItCore")){
    
  }
  PDNotificationHandler *handler = [PDNotificationHandler sharedInstance];
  [handler showRemoteNotification:userInfo completion:^(BOOL success){
    
  }];
  PDMessageAPIService *service = [[PDMessageAPIService alloc] init];
  [service markMessageAsRead:[userInfo[@"message_id"] integerValue] completion:^(NSError *error){
    
  }];
}

+ (BOOL) canOpenUrl:(NSURL*)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  if ([[url scheme] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"TwitterCallbackScheme"]]) {
    return YES;
  }
  if ([[url scheme] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"FacebookNamespace"]]) {
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

+ (BOOL) application:(UIApplication *)application
             openURL:(NSURL *)url
   sourceApplication:(NSString *)sourceApplication
          annotation:(id)annotation {
  //Twitter Login Callback
  if ([[url scheme] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"TwitterCallbackScheme"]]) {
    return [PopdeemSDK handleTwitterCallback:url sourceApplication:sourceApplication annotation:annotation];
  }
  //Facebook Deep Linking Handling
  if ([[url scheme] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"FacebookNamespace"]]) {
    return [PopdeemSDK processReferral:application url:url sourceApplication:sourceApplication annotation:annotation];
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
      return [PopdeemSDK processReferral:application url:url sourceApplication:sourceApplication annotation:annotation];
    }
  }
  return YES;
}

+ (BOOL) handleTwitterCallback:(NSURL *)url
             sourceApplication:(NSString *)sourceApplication
                    annotation:(id)annotation {
  NSDictionary *d = [PopdeemSDK parametersDictionaryFromQueryString:[url query]];
  PDSocialMediaManager *man = [PDSocialMediaManager manager];
  if (d[@"denied"]) {
    //User denied
    NSLog(@"User cancelled");
    [man userCancelledTwitterLogin];
  } else {
    NSString *token = d[@"oauth_token"];
    NSString *verifier = d[@"oauth_verifier"];
    [man setOAuthToken:token oauthVerifier:verifier];
  }
  return YES;
}

+ (BOOL) processReferral:(UIApplication *)application
                     url:(NSURL *)url
       sourceApplication:(NSString *)sourceApplication
              annotation:(id)annotation {
  PDReferral *r = [[PDReferral alloc] initWithUrl:url appRef:application];
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
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PopdeemNonSocialRegistered"] == nil) {
    PDUserAPIService *service = [[PDUserAPIService alloc] init];
    [service nonSocialUserInitWithCompletion:^(NSError *error){
      if (!error) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"PopdeemNonSocialRegistered"];
      } else {
        NSLog(@"Error registering non-social user: %@",error.localizedDescription);
      }
    }];
  }
}

+ (void) logMoment:(NSString*)momentString {
  [PDMomentsManager logMoment:momentString];
}

+ (void) setThirdPartyUserToken:(NSString*)userToken {
  [[PDAPIClient sharedInstance] setThirdPartyToken:userToken];
  if ([PDUser sharedInstance] == nil) {
    return;
  }
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service updateUserWithCompletion:^(PDUser *user, NSError *error){
    if (error) {
      NSLog(@"Error updating User");
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

@end