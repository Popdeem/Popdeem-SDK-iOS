//
//  PDUserTwitterParams.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 03/10/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDUserTwitterParams.h"

@implementation PDUserTwitterParams

- (nullable PDUserTwitterParams*) initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        NSInteger socId;
        if ([params[@"social_account_id"] isKindOfClass:[NSString class]]) {
            socId = [params[@"social_account_id"] integerValue];
        } else {
            socId = 0;
        }
        self.socialAccountId = socId;
        NSString *twid = params[@"twitter_id"];
        self.identifier  = ([twid isKindOfClass:[NSString class]]) ? twid : nil;
        NSString *accessToken = params[@"access_token"];
        if ([accessToken isKindOfClass:[NSString class]]) {
            if (accessToken.length > 0) {
                self.accessToken = accessToken;
            } else {
                self.accessToken = @"";
            }
        }
        NSString *accessSecret = params[@"access_secret"];
        if ([accessSecret isKindOfClass:[NSString class]]) {
            if (accessSecret.length > 0) {
                self.accessSecret = accessSecret;
            } else {
                self.accessSecret = @"";
            }
        }
        long expirationTime;
        if ([params[@"expiration_time"] isKindOfClass:[NSString class]] && [(NSString*)params[@"expiration_time"] length] > 0 ) {
            expirationTime = [params[@"expiration_time"] longValue];
        } else {
            expirationTime = 0;
        }
        self.expirationTime = expirationTime;
        NSString *ppurl = params[@"profile_picture_url"];
        self.profilePictureUrl = ([ppurl isKindOfClass:[NSString class]]) ? ppurl : nil;
        self.scores = [[PDScores alloc] initFromAPI:params[@"score"]];
        return self;
    }
    return nil;
}

@end
