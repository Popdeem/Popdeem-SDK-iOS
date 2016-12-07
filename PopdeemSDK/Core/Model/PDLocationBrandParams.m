//
//  PDLocationBrandParams.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 07/12/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDLocationBrandParams.h"

@implementation PDLocationBrandParams
- (instancetype) initWithDictionary:(NSDictionary*)dict {
	NSError *err;
	if (self = [super initWithDictionary:dict error:&err]) {
		return self;
	}
	PDLogError(@"JSONModel Error on Location Brand: %@", err);
	return nil;
}

+ (JSONKeyMapper*)keyMapper {
	return [JSONKeyMapper mapperForSnakeCase];
}
@end
