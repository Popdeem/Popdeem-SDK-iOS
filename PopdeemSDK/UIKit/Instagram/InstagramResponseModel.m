//
//  InstagramResponseModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 17/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "InstagramResponseModel.h"

@implementation InstagramResponseModel

- (id) initWithJSON:(NSString*)json {
	NSError *err;
	if (self = [super initWithString:json error:&err]) {
		return  self;
	}
	NSLog(@"JSONModel Error on Instagram Model: %@",err);
	return  nil;
}

+(JSONKeyMapper*)keyMapper {
	return [[JSONKeyMapper alloc] initWithDictionary:@{
																										 @"access_token": @"accessToken",
																										 @"user.username": @"userName",
																										 @"user.bio": @"bio",
																										 @"user.website": @"website",
																										 @"user.profile_picture": @"profilePictureUrlString",
																										 @"user.full_name": @"fullName",
																										 @"user.id": @"identifier"
																										 }];
}

@end
