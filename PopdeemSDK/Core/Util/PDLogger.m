//
//  PDLogger.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDLogger.h"
#import "PopdeemSDK.h"

@implementation PDLogger

+ (void) logMessage:(NSString*)message filename:(char*)filename line:(int)line, ...{
	if (![PopdeemSDK debugMode]) return;
	NSString *_filename = [NSString stringWithUTF8String:filename];
	NSString *pretty_message = [NSString stringWithFormat:@"Popdeem Debug Log\n\t[%@ : l%d]\n\t",_filename,line];
	NSString *full_message = [pretty_message stringByAppendingString:message];
	
	va_list args;
	va_start(args, full_message);
	NSLogv(full_message, args);
	va_end(args);
}


@end
