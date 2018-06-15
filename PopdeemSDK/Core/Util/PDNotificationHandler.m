//
//  PDNotificationHandler.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/12/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDNotificationHandler.h"
#import "PDAPIClient.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDUserAPIService.h"
#import "PDConstants.h"
#import "PDMessageAPIService.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface PDNotificationHandler()
@property (nonatomic) BOOL shouldGoToUrl;
@property (nonatomic, retain) NSString *url;
@property (nonatomic) BOOL shouldGoToDeepLink;
@property (nonatomic, retain) NSString *deeplink;
@property (nonatomic, copy) void (^completionBlock)(BOOL);
@property (nonatomic, strong) PDSDKCustomIOS7AlertView *alertView;
@end

@implementation PDNotificationHandler

- (instancetype) init {
  if (self = [super init]) {
    return self;
  }
  return nil;
}

+ (instancetype) sharedInstance {
  static dispatch_once_t pred;
  static PDNotificationHandler *sharedInstance = nil;
  dispatch_once(&pred, ^{
    sharedInstance = [[PDNotificationHandler alloc] init];
  });
  return sharedInstance;
}

- (void) registerForPushNotificationsApplication:(UIApplication *)application {
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
      if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = (id<UIApplicationDelegate, UNUserNotificationCenterDelegate>)application.delegate;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
          if(!error){
            dispatch_async(dispatch_get_main_queue(), ^{
              [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
          }
        }];
      } else {
        // Fallback on earlier versions
      }if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
      } else {
        // Fallback on earlier versions
      }
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [[PDAPIClient sharedInstance] setDeviceToken:deviceToken.description];
	if (![[PDUser sharedInstance] identifier]) {
    [[PopdeemSDK sharedInstance] nonSocialRegister];
		return;
	}
	PDUserAPIService *service = [[PDUserAPIService alloc] init];
	[service updateUserWithCompletion:^(PDUser *user, NSError *error) {
		if (error) {
			PDLogError(@"Error User Update: %@",error);
		}
	}];
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  
}

- (void) showRemoteNotification:(NSDictionary*)userInfo completion:(void (^)(BOOL success))completion {
  _completionBlock = completion;

  UIImage *fbImage = PopdeemImage(@"pduikit_fb_hi");
  UIImage *twImage = PopdeemImage(@"Twitter_Logo_Blue");
  UIImage *instaImage = PopdeemImage(@"pduikit_instagram_hi");
  
  _alertView = [[PDSDKCustomIOS7AlertView alloc] init];
  
  UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 220)];
  
  UIImageView *twImageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentView.center.x-15, 35, 40, 30)];
  twImageView.contentMode = UIViewContentModeScaleAspectFit;
  twImageView.layer.masksToBounds = YES;
  [twImageView setImage:twImage];
  
  UIImageView *fbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentView.center.x-65, 35, 40, 30)];
  fbImageView.contentMode = UIViewContentModeScaleAspectFit;
  fbImageView.layer.masksToBounds = YES;
  [fbImageView setImage:fbImage];
  
  UIImageView *inImageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentView.center.x+35, 35, 40, 30)];
  inImageView.contentMode = UIViewContentModeScaleAspectFit;
  inImageView.layer.masksToBounds = YES;
  [inImageView setImage:instaImage];
  
  [contentView addSubview:fbImageView];
  [contentView addSubview:twImageView];
  [contentView addSubview:inImageView];
  
  float currentY = 35 + 40 + 15;
  
  UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, contentView.center.y-12.5, contentView.frame.size.width, 25)];
  [title setTextAlignment:NSTextAlignmentCenter];
  if (PopdeemThemeHasValueForKey(PDThemeFontBold)) {
    [title setFont:PopdeemFont(PDThemeFontBold, 16)];
  } else {
    [title setFont:[UIFont systemFontOfSize:16]];
  }
  [title setText:[userInfo objectForKey:@"body"]];
  [title setTextColor:[UIColor blackColor]];
  [contentView addSubview:title];
  
  currentY = contentView.center.y + 12.5;
  
  UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(30, currentY, contentView.frame.size.width-60, (contentView.frame.size.height/2) - 25)];
  message.lineBreakMode = NSLineBreakByWordWrapping;
  message.numberOfLines = 0;
  [message setTextAlignment:NSTextAlignmentCenter];
  [message setFont:PopdeemFont(PDThemeFontPrimary, 12)];
  [message setText:@"Earn additional rewards.\nCheck out our 'Social' section in the menu to earn bonus rewards."];
  [message setTextColor:[UIColor darkGrayColor]];
  [contentView addSubview:message];
  
  [_alertView setContainerView:contentView];
  if ([userInfo objectForKey:@"target_url"]) {
    [self presentUrlAlert:_alertView url:[userInfo objectForKey:@"target_url"]];
  } else if ([userInfo objectForKey:@"deep_link"]) {
    [self presentDeepLinkAlert:_alertView deepLink:[userInfo objectForKey:@"deep_link"]];
  } else {
    [self presentAppAlert:_alertView];
  }
	
	NSInteger badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
	if (badgeNumber > 0) {
		badgeNumber = badgeNumber - 1;
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
	}
    
    //Mark incoming message as read (user got it)
    NSInteger messageId = [[userInfo objectForKey:@"message_id"] integerValue];
    if (messageId != 0) {
        PDMessageAPIService *service = [[PDMessageAPIService alloc] init];
        [service markMessageAsRead:messageId completion:^(NSError *error) {
            if (error) {
                PDLog(@"Mark Message as read error: %@", error);
            }
        }];
    }
	
}

- (void) presentUrlAlert:(PDSDKCustomIOS7AlertView*)alertView url:(NSString*)url {
  _url = url;
  _shouldGoToUrl = YES;
  _shouldGoToDeepLink = NO;
  [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Dismiss", @"GO", nil]];
  [alertView setUseMotionEffects:TRUE];
  [alertView setDelegate:self];
  [alertView show];
}

- (void) presentDeepLinkAlert:(PDSDKCustomIOS7AlertView*)alertView deepLink:(NSString*)deepLink {
  _deeplink = deepLink;
  _shouldGoToDeepLink = YES;
  _shouldGoToUrl = NO;
  [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Dismiss", @"GO", nil]];
  [alertView setUseMotionEffects:TRUE];
  [alertView setDelegate:self];
  [alertView show];
}

- (void) presentAppAlert:(PDSDKCustomIOS7AlertView*)alertView {
  _shouldGoToUrl = NO;
  _shouldGoToDeepLink = NO;
  [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"OK", nil]];
  [alertView setUseMotionEffects:TRUE];
  [alertView setDelegate:self];
  [alertView show];
}

- (void) customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    [alertView removeFromSuperview];
    _completionBlock(YES);
  } else {
    if (_shouldGoToUrl && _url) {
      if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
        _completionBlock(YES);
        [[NSNotificationCenter defaultCenter] postNotificationName:DirectToSocialHome object:nil];
      } else {
        [alertView removeFromSuperview];
        _completionBlock(NO);
        [[NSNotificationCenter defaultCenter] postNotificationName:DirectToSocialHome object:nil];
      }
    } else if (_shouldGoToDeepLink && _deeplink) {
      if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_deeplink]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_deeplink]];
        _completionBlock(YES);
      } else {
        [alertView removeFromSuperview];
        _completionBlock(NO);
        [[NSNotificationCenter defaultCenter] postNotificationName:DirectToSocialHome object:nil];
      }
    } else {
      PDLog(@"Could not open attachment");
      [alertView removeFromSuperview];
      _completionBlock(NO);
        [[NSNotificationCenter defaultCenter] postNotificationName:DirectToSocialHome object:nil];
    }
  }
}

@end
