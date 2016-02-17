//
//  PDUserFacebookParams.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDUserFacebookParams.h"

@implementation PDUserFacebookParams

- (id) init {
  if (self = [super init]) {
    return self;
  }
  return nil;
}

- (nullable PDUserFacebookParams*) initWithParams:(NSDictionary *)params {
  if (self = [super init]) {
    NSInteger socId = [params[@"social_account_id"] integerValue];
    self.socialAccountId = socId;
    NSString *fbid = params[@"facebook_id"];
    self.identifier  = ([fbid isKindOfClass:[NSString class]]) ? fbid : nil;
    NSString *accessToken = params[@"access_token"];
    self.accessToken = ([accessToken isKindOfClass:[NSString class]]) ? accessToken : nil;
    long expirationTime = [params[@"expiration_time"] longValue];
    self.expirationTime = expirationTime;
    NSString *ppurl = params[@"profile_picture_url"];
    self.profilePictureUrl = ([ppurl isKindOfClass:[NSString class]]) ? ppurl : nil;
  
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params[@"score"]
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    self.scores = [[PDScores alloc] initWithJSON:jsonString];
    if (params[@"default_privacy_setting"]) {
      self.defaultPrivacySetting = params[@"default_privacy_setting"];
    }
    return self;
  }
  return nil;
}

@end
