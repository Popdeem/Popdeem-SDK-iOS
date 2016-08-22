//
//  PDLogger.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDLogger.h"
#import "PopdeemSDK.h"

@implementation PDLogger

+ (instancetype)sharedInstance {
	static dispatch_once_t once;
	static id sharedInstance;
	dispatch_once(&once, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (void) log:(NSString *)fmt {
	if ([[PopdeemSDK sharedInstance] debug]) {
		NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
	}
}

@end
