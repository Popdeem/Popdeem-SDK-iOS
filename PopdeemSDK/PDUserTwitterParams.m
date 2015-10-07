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
        NSInteger socId = [params[@"social_account_id"] integerValue];
        self.socialAccountId = socId;
        NSString *twid = params[@"twitter_id"];
        self.identifier  = ([twid isKindOfClass:[NSString class]]) ? twid : nil;
        NSString *accessToken = params[@"access_token"];
        self.accessToken = ([accessToken isKindOfClass:[NSString class]]) ? accessToken : nil;
        long expirationTime = [params[@"expiration_time"] longValue];
        self.expirationTime = expirationTime;
        NSString *ppurl = params[@"profile_picture_url"];
        self.profilePictureUrl = ([ppurl isKindOfClass:[NSString class]]) ? ppurl : nil;
        self.scores = [[PDScores alloc] initFromAPI:params[@"score"]];
        return self;
    }
    return nil;
}

@end
