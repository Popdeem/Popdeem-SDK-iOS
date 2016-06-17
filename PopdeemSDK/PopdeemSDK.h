//
//
//
//                        /\
//      \`               /##\               ´/
//       \   `          /####\          ´   /
//        \     `      /######\      ´     /
//         \       `  /########\  ´       /
//          \        /##########\        /
//           \      /############\      /
//            \    /##############\    /
//             \  /################\  /
//              \/##################\/
// _____   ____  _____  _____  ______ ______ __  __
//|  __ \ / __ \|  __ \|  __ \|  ____|  ____|  \/  |
//| |__) | |  | | |__) | |  | | |__  | |__  |      |
//|  ___/| |  | |  ___/| |  | |  __| |  __| | |\/| |
//| |    | |__| | |    | |__| | |____| |____| |  | |
//|_|     \____/|_|    |_____/|______|______|_|  |_|
//
//
//
//  PopdeemSDK.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
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

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"


NS_ASSUME_NONNULL_BEGIN

@interface PopdeemSDK : NSObject

@property (nonatomic, strong) NSString *apiKey;

+ (id) sharedInstance;
+ (void) withAPIKey:(NSString*)apiKey;
+ (void) testingWithAPIKey:(NSString*)apiKey;

+ (void) setTwitterOAuthToken:(NSString*)token verifier:(NSString*)verifier;

+ (void) enableSocialLoginWithNumberOfPrompts:(NSInteger) noOfPrompts;

+ (void) setUpThemeFile:(NSString*)themeName;

+ (void) presentRewardFlow;
+ (void) presentHomeFlowInNavigationController:(UINavigationController*)navController;
+ (void) pushRewardsToNavigationController:(UINavigationController*)navController animated:(BOOL)animated;

+ (void) registerForPushNotificationsApplication:(UIApplication *)application;
+ (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
+ (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
+ (void) handleRemoteNotification:(NSDictionary*)userInfo;
+ (BOOL) canOpenUrl:(NSURL*)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;
+ (BOOL) application:(UIApplication *)application
             openURL:(NSURL *)url
   sourceApplication:(NSString *)sourceApplication
          annotation:(id)annotation;
+ (void) logMoment:(NSString*)momentString;
+ (void) setThirdPartyUserToken:(NSString*)userToken;

+ (void) logout;

+ (NSString*) instagramClientId;
+ (NSString*) instagramClientSecret;
+ (NSString*) instagramCallback;
@end
NS_ASSUME_NONNULL_END
