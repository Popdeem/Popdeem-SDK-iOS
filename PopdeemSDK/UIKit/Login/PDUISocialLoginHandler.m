;//
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
#import "PopdeemSDK.h"
#import "PDMultiLoginViewController.h"
#import "PDMultiLoginViewControllerV2.h"
#import "PDRewardStore.h"
#import "PDRewardApiService.h"

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
        PDLogError(@"Something went wrong, Error: %@",error.localizedDescription);
      }
      if ([[[PDUser sharedInstance] facebookParams] accessToken] != nil) {
        [[PDSocialMediaManager manager] checkFacebookTokenIsValid:^(BOOL valid){
          if (valid) {
            [[PDUser sharedInstance] refreshFacebookFriendsCallback:^(BOOL response){
              PDLog(@"Facebook Friends Updated");
            }];
          } else {
            return;
          }
        }];
      }
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

- (void) fetchSocialLoginReward:(void (^)(PDReward *reward))completion {
  NSArray *rewards = [PDRewardStore allRewards];
  if (rewards.count == 0) {
    PDRewardAPIService *service = [[PDRewardAPIService alloc] init];
    [service getAllRewardsWithCompletion:^(NSError *error) {
      for (PDReward* reward in [PDRewardStore allRewards]){
        if (reward.action == PDRewardActionSocialLogin) {
          completion(reward);
          return;
        }
      }
      completion(nil);
      return;
    }];
  } else {
    for (PDReward* reward in [PDRewardStore allRewards]){
      if (reward.action == PDRewardActionSocialLogin) {
        completion(reward);
        return;
      }
    }
    completion(nil);
    return;
  }
}

- (void) presentLoginModal {
  [self fetchSocialLoginReward:^(PDReward *reward) {
      
      UIViewController *topController = [PDUIKitUtils topViewController];
      NSString *socialLoginVariation = PopdeemSocialLoginVariation(PDThemeSocialLoginVariation);
      
      if  ([socialLoginVariation isEqualToString:PDSocialLoginDesignVariation1]) {
          
        PDMultiLoginViewController *vc = [[PDMultiLoginViewController alloc] initFromNibWithReward:reward];
          
          vc.modalPresentationStyle = UIModalPresentationFullScreen;
          
          [topController setModalPresentationStyle:UIModalPresentationOverFullScreen];
          [topController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
          
          [topController presentViewController:vc animated:YES completion:^{}];
          [self setUsesCount:self.usesCount+1];
          PDLog(@"Login Count: %lu",(unsigned long)[self usesCount]);
          
          [self logSocialLoginTakeoverCount];
    
      }
       else if ([socialLoginVariation isEqualToString:PDSocialLoginDesignVariation2]) {
        PDMultiLoginViewControllerV2 *vc = [[PDMultiLoginViewControllerV2 alloc] initFromNibWithReward:reward];
           
           NSString *socialLoginTransition = PopdeemSocialLoginTransition(PDThemeSocialLoginTransition);
           
           vc.modalPresentationStyle = UIModalPresentationFullScreen;
           
           if ([socialLoginTransition isEqualToString:PDSocialLoginTransition2]) {
               
               CATransition *transition = [CATransition animation];
               transition.duration = 0.3;
               transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
               transition.type = kCATransitionPush;
               transition.subtype = kCATransitionFromRight;
               [topController.view.window.layer addAnimation:transition forKey:nil];
               [topController presentViewController:vc animated:NO completion:nil];
  
           } else {
                [topController presentViewController:vc animated:YES completion:^{}];
            }
           [self setUsesCount:self.usesCount+1];
           PDLog(@"Login Count: %lu",(unsigned long)[self usesCount]);
           
           [self logSocialLoginTakeoverCount];
           
       }
       else {
        PDMultiLoginViewController *vc = [[PDMultiLoginViewController alloc] initFromNibWithReward:reward];
           
           vc.modalPresentationStyle = UIModalPresentationFullScreen;
           
           [topController setModalPresentationStyle:UIModalPresentationOverFullScreen];
           [topController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
           
           [topController presentViewController:vc animated:YES completion:^{}];
           [self setUsesCount:self.usesCount+1];
           PDLog(@"Login Count: %lu",(unsigned long)[self usesCount]);
           
           [self logSocialLoginTakeoverCount];
      }
      
  }];
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


- (void) logSocialLoginTakeoverCount {
    
    switch ([self usesCount]) {
        case 1:
            NSLog(@"Log Login Takeover 1");
            AbraLogEvent(ABRA_EVENT_SHOW_LOGIN_TAKEOVER_1, @{@"Source" : @"Social Login Takeover"});
            break;
        case 2:
            NSLog(@"Log Login Takeover 2");
            AbraLogEvent(ABRA_EVENT_SHOW_LOGIN_TAKEOVER_2, @{@"Source" : @"Social Login Takeover"});
            break;
        case 3:
            NSLog(@"Log Login Takeover 3");
            AbraLogEvent(ABRA_EVENT_SHOW_LOGIN_TAKEOVER_3, @{@"Source" : @"Social Login Takeover"});
            break;
        case 4:
            NSLog(@"Log Login Takeover 4");
            AbraLogEvent(ABRA_EVENT_SHOW_LOGIN_TAKEOVER_4, @{@"Source" : @"Social Login Takeover"});
            break;
        case 5:
            NSLog(@"Log Login Takeover 5");
            AbraLogEvent(ABRA_EVENT_SHOW_LOGIN_TAKEOVER_5, @{@"Source" : @"Social Login Takeover"});
            break;
        default:
            break;
    }
}


@end
