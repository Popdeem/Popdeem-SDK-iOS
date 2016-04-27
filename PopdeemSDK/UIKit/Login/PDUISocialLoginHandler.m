//
//  PDSocialLoginHandler.m
//  PopdeemSDK
//
//  Created by John Doran on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDUISocialLoginHandler.h"
#import "PDUISocialLoginViewController.h"
#import "PDSocialMediaManager.h"
#import "PDUIKitUtils.h"
#import "PDUser.h"
#import "PDUserAPIService.h"
#import "PDUser+Facebook.h"

static NSString *const PDUseCountKey = @"PDUseCount";

@interface PDUISocialLoginHandler()
@property (nonatomic, assign) NSUInteger usesCount;
@property (nonatomic, assign) NSUInteger maxPrompts;
@property (nonatomic, strong) PDSocialMediaManager *socialManager;
@end

@implementation PDUISocialLoginHandler

- (instancetype) init{
  if(self = [super init]){
    self.socialManager = [PDSocialMediaManager manager];
  }
  return self;
}

- (void)showPromptIfNeededWithMaxAllowed:(NSNumber*)numberOfTimes  {
  self.maxPrompts = numberOfTimes.integerValue;
  
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"popdeemUser"]){
    [PDUser initFromUserDefaults:[[NSUserDefaults standardUserDefaults] objectForKey:@"popdeemUser"]];
    PDUserAPIService *apiService = [[PDUserAPIService alloc] init];
    PDUser *user = [PDUser sharedInstance];
    [apiService getUserDetailsForId:[NSString stringWithFormat:@"%ld",(long)user.identifier] authenticationToken:user.userToken completion:^(PDUser *user, NSError *error){
      if (error) {
        NSLog(@"Something went wrong");
      }
      [[PDUser sharedInstance] refreshFacebookFriendsCallback:^(BOOL response){
        NSLog(@"Facebook Friends Updated");
      }];
    }];
    return;
  }
  
  if ([self shouldShowPrompt]) {
    [self performSelector:@selector(presentLoginModal) withObject:nil afterDelay:0.4];
  }
}

- (BOOL)shouldShowPrompt {
  return  ([self usesCount] < self.maxPrompts) && ![self.socialManager isLoggedIn];
}

- (void) presentLoginModal {
  UIViewController *topController = [PDUIKitUtils topViewController];
  [topController setModalPresentationStyle:UIModalPresentationOverFullScreen];
  
  PDUISocialLoginViewController *vc = [[PDUISocialLoginViewController alloc] initWithLocationServices:YES];
  [topController presentViewController:vc animated:YES completion:^{}];
  [self setUsesCount:self.usesCount+1];
  NSLog(@"Login Count: %i",self.usesCount);
}

- (NSUInteger)usesCount {
  if ([[NSUserDefaults standardUserDefaults] integerForKey:PDUseCountKey]) {
    return [[NSUserDefaults standardUserDefaults] integerForKey:PDUseCountKey];
  }
  return 0;
}

- (void)setUsesCount:(NSUInteger)count {
  [[NSUserDefaults standardUserDefaults] setInteger:(NSInteger)count forKey:PDUseCountKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)numberOfPromptsAllowed {
  return [[NSUserDefaults standardUserDefaults] integerForKey:PDUseCountKey]? : 0;
}


@end