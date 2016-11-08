//
//  PDLogger.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <string.h>

#define __FILENAME__ (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)

#define PDLog(fmt, ...) [PDLogger logMessage:(@"" fmt) filename:__FILENAME__ line:__LINE__ alert:NO, ##__VA_ARGS__]

#define PDLogAlert(fmt, ...) [PDLogger logMessage:(@"" fmt) filename:__FILENAME__ line:__LINE__ alert:YES, ##__VA_ARGS__]

#define PDLogError(fmt, ...) NSLog((@"❗️Popdeem Error:\n\tLocation: %s, Line %d\n\tMessage: " fmt), __FILENAME__, __LINE__, ##__VA_ARGS__)

@interface PDLogger : NSObject
+ (void) logMessage:(NSString*)message filename:(char*)filename line:(int)line alert:(BOOL)alert, ...;

@end
