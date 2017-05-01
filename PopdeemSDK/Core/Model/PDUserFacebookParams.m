//
//  PDUserFacebookParams.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDUserFacebookParams.h"
#import "PDLogger.h"

@implementation PDUserFacebookParams

- (id) init {
  if (self = [super init]) {
    return self;
  }
  return nil;
}

- (instancetype) initWithDictionary:(NSDictionary*)dict {
	NSError *err;
	if (self = [super initWithDictionary:dict error:&err]) {
		return self;
	}
	PDLogError(@"JSONModel Error on PDUserFacebookParams: %@",err);
	return nil;
}

+ (JSONKeyMapper*)keyMapper {
	return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
																										 @"access_token": @"accessToken",
																										 @"facebook_id": @"identifier",
																										 @"expiration_time": @"expirationTime",
																										 @"profile_picture_url": @"profilePictureUrl",
																										 @"score": @"scores",
																										 @"social_account_id": @"socialAccountId",
																										 @"tester": @"isTester",
																										 @"favourite_brand_ids": @"favouriteBrandIds",
																										 @"default_privacy_setting": @"defaultPrivacySetting"
																										 }];
}

@end
