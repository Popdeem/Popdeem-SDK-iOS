//
//  AppDelegate.m
//  PopdeemSample
//
//  Created by niall quinn on 01/05/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import "AppDelegate.h"
#import "PopdeemSDK.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  [PopdeemSDK withAPIKey:@"26eb2fcb-06e5-4976-bff4-88c30cc58f58"];
  [PopdeemSDK enableSocialLoginWithNumberOfPrompts:300];
  [PopdeemSDK registerForPushNotificationsApplication:application];
  [PopdeemSDK setUpThemeFile:@"theme"];
  [PopdeemSDK setDebug:YES];
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

- (BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
  
  BOOL wasHandled = [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                   openURL:url
                                                         sourceApplication:options[@"UIApplicationOpenURLOptionsSourceApplicationKey"]
                                                                annotation:nil];
  
  if (wasHandled) return wasHandled;
  
  if ([PopdeemSDK canOpenUrl:url sourceApplication:options[@"UIApplicationOpenURLOptionsSourceApplicationKey"] annotation:nil]) {
    return [PopdeemSDK application:app
                           openURL:url
                 sourceApplication:options[@"UIApplicationOpenURLOptionsSourceApplicationKey"]
                        annotation:nil];
  }
  
  return NO;
  
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
