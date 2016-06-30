//
//  PDUserInstagramParams.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUserInstagramParams.h"

@implementation PDUserInstagramParams

- (id) initWithJSON:(NSString*)json {
	NSError *err;
	if (self = [super initWithString:json error:&err]) {
		return  self;
	}
	NSLog(@"JSONModel Error on Instagram Params: %@",err);
	return  nil;
}

- (id) initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
	if ([super initWithDictionary:dict error:&err]) {
		return self;
	}
	NSLog(@"JSONModel Error on Instagram Params: %@",err);
	return nil;
}

+ (JSONKeyMapper*)keyMapper {
	return [[JSONKeyMapper alloc] initWithDictionary:@{
																										 @"social_account_id": @"socialAccountId",
																										 @"instagram_id": @"instagramId",
																										 @"tester": @"isTester",
																										 @"access_token": @"accessToken",
																										 @"access_secret": @"accessSecret",
																										 @"profile_picture_url": @"profilePictureUrl",
																										 @"screen_name": @"screenName"
																										 }];
}

@end
