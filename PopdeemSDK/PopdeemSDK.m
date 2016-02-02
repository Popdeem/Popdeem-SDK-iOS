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
#import "PDRewardTableViewController.h"
#import "PDUserAPIService.h"

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
//  [SDK nonSocialRegister];
}

+ (void) setTwitterOAuthToken:(NSString*)token verifier:(NSString*) verifier {
  [[PDSocialMediaManager manager] setOAuthToken:token oauthVerifier:verifier];
}

+ (void) enableSocialLoginWithNumberOfPrompts:(NSInteger) noOfPrompts {
  id uiKitCore = [[self sharedInstance]popdeemUIKitCore];
  SEL selector = NSSelectorFromString(@"enableSocialLoginWithNumberOfPrompts:");
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [uiKitCore performSelector:selector withObject:@(noOfPrompts)];
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

- (void) nonSocialRegister {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PopdeemNonSocialRegistered"] == nil) {
    PDUserAPIService *service = [[PDUserAPIService alloc] init];
    [service nonSocialUserInitWithCompletion:^(NSError *error){
      if (!error) {
//        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"PopdeemNonSocialRegistered"];
      } else {
        NSLog(@"Error registering non-social user: %@",error.localizedDescription);
      }
    }];
  }
}

@end