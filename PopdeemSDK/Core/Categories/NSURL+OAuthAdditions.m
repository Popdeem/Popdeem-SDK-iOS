//
//  NSURL+OAuthAdditions.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "NSURL+OAuthAdditions.h"

@implementation NSURL (OAuthAdditions)

- (NSString *)URLStringWithoutQuery {
	NSArray *parts = [[self absoluteString] componentsSeparatedByString:@"?"];
	return [parts objectAtIndex:0];
}

@end
