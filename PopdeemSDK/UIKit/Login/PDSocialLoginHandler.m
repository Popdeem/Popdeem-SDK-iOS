//
//  PDSocialLoginHandler.m
//  PopdeemSDK
//
//  Created by John Doran Home on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDSocialLoginHandler.h"
#import "PDSocialLoginViewController.h"
#import "PDSocialMediaManager.h"
#import "PDUIKitUtils.h"

static NSString *const PDUseCountKey = @"PDUseCount";

@interface PDSocialLoginHandler()
@property (nonatomic, assign) NSUInteger usesCount;
@property (nonatomic, assign) NSUInteger maxPrompts;
@property (nonatomic, strong) PDSocialMediaManager *socialManager;
@end

@implementation PDSocialLoginHandler

- (instancetype)init{
    if(self = [super init]){
        self.socialManager = [PDSocialMediaManager manager];
    }
    return self;
}

- (void)showPromptIfNeededWithMaxAllowed:(NSNumber*)numberOfTimes  {
    self.maxPrompts = numberOfTimes.integerValue;
    
    if ([self shouldShowPrompt]) {
        [self performSelector:@selector(presentLoginModal) withObject:nil afterDelay:0.2];
    }
}

- (BOOL)shouldShowPrompt {
    return   (self.usesCount < self.maxPrompts) && ![self.socialManager isLoggedIn];
}

- (void) presentLoginModal {
    [[self topViewController] setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    PDSocialLoginViewController *vc = [[PDSocialLoginViewController alloc] initWithLocationServices:YES];
    [[self topViewController] presentViewController:vc animated:YES completion:^{}];
    
    NSLog(@"Showing popdeem social login");
    [self setUsesCount:self.usesCount+1];
}

- (NSUInteger)usesCount {
    return [[NSUserDefaults standardUserDefaults] integerForKey:PDUseCountKey]? : 0;
}

- (void)setUsesCount:(NSUInteger)count {
    [[NSUserDefaults standardUserDefaults] setInteger:(NSInteger)count forKey:PDUseCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)numberOfPromptsAllowed {
    return [[NSUserDefaults standardUserDefaults] integerForKey:PDUseCountKey]? : 0;
}

//TODO - test varying app client app types
- (UIViewController *)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *) rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *) rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end