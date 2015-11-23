//
//  PDSocialLoginHandler.m
//  PopdeemSDK
//
//  Created by John Doran Home on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDSocialLoginHandler.h"

static NSString *const PDUseCountKey = @"PDUseCount";

@interface PDSocialLoginHandler()
@property (nonatomic, assign) NSUInteger usesCount;
@property (nonatomic, assign) NSUInteger maxPrompts;
@end

@implementation PDSocialLoginHandler

- (void)showPromptIfNeededWithMaxAllowed:(NSInteger)numberOfTimes  {
    self.maxPrompts = numberOfTimes;

    if(self.usesCount  < self.maxPrompts){
        //TODO hookup nialls ui
        //[self showSocialLogin];
        NSLog(@"Showing social login");
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

@end