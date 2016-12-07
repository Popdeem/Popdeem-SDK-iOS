//
//  PDBrandTheme.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 07/12/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDBrandTheme.h"

@implementation PDBrandTheme

- (id) initWithJSON:(NSString*)json {
	NSError *err;
	if (self = [super initWithString:json error:&err]) {
		return  self;
	}
	PDLogError(@"JSONModel Error on Brand Theme: %@",err);
	return  nil;
}

+(JSONKeyMapper*)keyMapper {
	return [JSONKeyMapper mapperForSnakeCase];
}

@end
