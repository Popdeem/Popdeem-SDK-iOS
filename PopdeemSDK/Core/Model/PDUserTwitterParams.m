//
//  PDUserTwitterParams.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 03/10/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDUserTwitterParams.h"
#import "PDLogger.h"

@implementation PDUserTwitterParams

- (nullable instancetype) initWithDictionary:(NSDictionary *)dict {
	NSError *err = [[NSError alloc] init];
	if (self = [super initWithDictionary:dict error:&err]) {
		return self;
	}
	PDLogError(@"JSONModel Error on Twitter Params: %@", err);
	return nil;
}

+ (JSONKeyMapper*)keyMapper {
	return [[JSONKeyMapper alloc] initWithDictionary:@{
																										 @"access_token": @"accessToken",
																										 @"access_secret": @"accessSecret",
																										 @"twitter_id": @"identifier",
																										 @"profile_picture_url": @"profilePictureUrl",
																										 @"social_account_id": @"socialAccountId",
																										 @"tester": @"isTester",
																										 @"favourite_brand_ids": @"favouriteBrandIds"
																										 }];
}
@end
