//
//  PDNotificationHandler.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/12/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDSDKCustomIOS7AlertView.h"

@interface PDNotificationHandler : NSObject <PDSDKCustomIOS7AlertViewDelegate>
+ (instancetype) sharedInstance;
- (void) registerForPushNotificationsApplication:(UIApplication *)application;
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void) showRemoteNotification:(NSDictionary*)userInfo completion:(void (^)(BOOL success))completion;
@end
