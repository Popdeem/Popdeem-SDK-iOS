//
//  AppDelegate.m
//  NavigationSample
//
//  Created by Niall Quinn on 04/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "AppDelegate.h"
#import "PopdeemSDK.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PDSocialLoginHandler.h"
#import "PDSocialMediaManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  [PopdeemSDK withAPIKey:@"43507f68-eeab-49e7-abf0-da099b14f17f"];
  // UIKIT
  [PopdeemSDK enableSocialLoginWithNumberOfPrompts:3];
  [PopdeemSDK registerForPushNotificationsApplication:application];
  [PopdeemSDK setUpThemeFile:@"theme"];
  return YES;
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [PopdeemSDK application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  [PopdeemSDK application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  if ([[userInfo objectForKey:@"sender"] isEqualToString:@"popdeem"]) {
    [PopdeemSDK handleRemoteNotification:userInfo];
    return;
  }
}

- (BOOL) application:(UIApplication *)application
             openURL:(NSURL *)url
   sourceApplication:(NSString *)sourceApplication
          annotation:(id)annotation {
  
  if ([[url scheme] isEqualToString:@"popdeemstagingtwitter"]) {
    NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
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
  
  // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
  //TODO: We could maybe take this into a Popdeem class and lighten the FB integration burden?
  BOOL wasHandled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                   openURL:url
                                                         sourceApplication:sourceApplication
                                                                annotation:annotation];
  
  // You can add your app-specific url handling code here if needed
  
  return wasHandled;
}

- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
  
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

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBSDKAppEvents activateApp];
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
