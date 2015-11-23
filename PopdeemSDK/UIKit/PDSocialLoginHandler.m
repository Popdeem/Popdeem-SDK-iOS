//
//  PDSocialLoginHandler.m
//  PopdeemSDK
//
//  Created by John Doran Home on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDSocialLoginHandler.h"

@implementation PDSocialLoginHandler

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidLaunch)
                                                 name:@"UIApplicationDidFinishLaunchingNotification" object:nil];
    
}

- (void)appDidLaunch {
    NSLog(@"did launch");
}

@end