//
//  InstagramResponseModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 17/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PopdeemSDK.h"
#import "InstagramResponseModel.h"

@implementation InstagramResponseModel

- (id) initWithJSON:(NSString*)json {
	NSError *err;
	if (self = [super initWithString:json error:&err]) {
		return  self;
	}
	PDLogError(@"JSONModel Error on Instagram Model: %@",err);
	return  nil;
}

+ (JSONKeyMapper *)keyMapper
{
	return [JSONKeyMapper mapperForSnakeCase];
}

@end

@implementation InstagramUserModel

+ (JSONKeyMapper *)keyMapper
{
	return [JSONKeyMapper mapperForSnakeCase];
}

@end
