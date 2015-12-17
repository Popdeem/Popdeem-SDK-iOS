//
//  PDNotificationHandler.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/12/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDNotificationHandler.h"
#import "PDAPIClient.h"

@interface PDNotificationHandler()
@property (nonatomic) BOOL shouldGoToUrl;
@property (nonatomic, retain) NSString *url;
@property (nonatomic) BOOL shouldGoToDeepLink;
@property (nonatomic, retain) NSString *deeplink;
@property (nonatomic, copy) void (^completionBlock)(BOOL);
@property (nonatomic, strong) PDCustomIOS7AlertView *alertView;
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
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
  } else {
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
  }
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [[PDAPIClient sharedInstance] setDeviceToken:deviceToken.description];
}

- (void) showRemoteNotification:(NSDictionary*)userInfo completion:(void (^)(BOOL success))completion {
  _completionBlock = completion;
  NSString *imageUrl = [userInfo objectForKey:@"image_url"];
  UIImage *image;
  if ([imageUrl isKindOfClass:[NSNull class]]) {
    image = [UIImage imageNamed:@"message_icon"];
  } else {
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"popdeem-dev" withString:@"popdeem"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    image = [UIImage imageWithData:imageData];
  }
  image = [UIImage imageNamed:@"message_icon"];
  _alertView = [[PDCustomIOS7AlertView alloc] init];
  
  UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 160)];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentView.center.x-40,5, 80, 80)];
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageView.layer.cornerRadius = 5.0;
  imageView.layer.masksToBounds = YES;
  imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
  imageView.layer.borderWidth = 1.0f;
  [imageView setImage:image];
  
  [contentView addSubview:imageView];
  
  UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, contentView.frame.size.width, 25)];
  [title setTextAlignment:NSTextAlignmentCenter];
  [title setFont:[UIFont boldSystemFontOfSize:16]];
  [title setText:[userInfo objectForKey:@"title"]];
  [title setTextColor:[UIColor blackColor]];
  [contentView addSubview:title];
  
  UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, contentView.frame.size.width-20, 35)];
  message.lineBreakMode = NSLineBreakByWordWrapping;
  message.numberOfLines = 2;
  [message setTextAlignment:NSTextAlignmentCenter];
  [message setFont:[UIFont systemFontOfSize:14]];
  [message setText:[userInfo objectForKey:@"content"]];
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
}

- (void) presentUrlAlert:(PDCustomIOS7AlertView*)alertView url:(NSString*)url {
  _url = url;
  _shouldGoToUrl = YES;
  _shouldGoToDeepLink = NO;
  [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Dismiss", @"GO", nil]];
  [alertView setUseMotionEffects:TRUE];
  [alertView setDelegate:self];
  [alertView show];
}

- (void) presentDeepLinkAlert:(PDCustomIOS7AlertView*)alertView deepLink:(NSString*)deepLink {
  _deeplink = deepLink;
  _shouldGoToDeepLink = YES;
  _shouldGoToUrl = NO;
  [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Dismiss", @"GO", nil]];
  [alertView setUseMotionEffects:TRUE];
  [alertView setDelegate:self];
  [alertView show];
}

- (void) presentAppAlert:(PDCustomIOS7AlertView*)alertView {
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
      } else {
        [alertView removeFromSuperview];
        _completionBlock(NO);
      }
    } else if (_shouldGoToDeepLink && _deeplink) {
      if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_deeplink]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_deeplink]];
        _completionBlock(YES);
      } else {
        [alertView removeFromSuperview];
        _completionBlock(NO);
      }
    } else {
      NSLog(@"Could not open attachment");
      [alertView removeFromSuperview];
      _completionBlock(NO);
    }
  }
}

@end
