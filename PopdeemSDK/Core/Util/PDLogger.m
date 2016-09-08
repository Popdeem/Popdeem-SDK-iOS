//
//  PDLogger.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDLogger.h"

@implementation PDLogger

+ (void) logMessage:(NSString*)message filename:(char*)filename line:(int)line, ...{
	NSString *pretty_message = [NSString stringWithFormat:@"Popdeem Debug Log:\n\t [%@ : line %d]\n\t Message:",filename,line];
	va_list args;
	va_start(args, pretty_message);
	NSLog(pretty_message, args);
	va_end(args);
}

@end
