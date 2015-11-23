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

static NSString *const PDUseCountKey = @"PDUseCount";

@interface PDSocialLoginHandler()
@property (nonatomic, assign) NSUInteger usesCount;
@property (nonatomic, assign) NSUInteger maxPrompts;
@end

@implementation PDSocialLoginHandler

- (void)showPromptIfNeededWithMaxAllowed:(NSNumber*)numberOfTimes  {
    self.maxPrompts = numberOfTimes.integerValue;

    if(self.usesCount  < self.maxPrompts){
        [[self topViewController] presentViewController:[[PDSocialLoginViewController alloc] initFromNib] animated:YES completion:^{}];
        NSLog(@"Showing popdeem social login");
        [self setUsesCount:self.usesCount+1];
    }
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

- (UIViewController *)topViewController {
//TODO: this failed for single view application
//After embedding the initial vc in a navigation controller in storboard, it worked
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