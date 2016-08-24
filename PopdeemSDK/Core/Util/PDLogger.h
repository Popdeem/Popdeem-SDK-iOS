//
//  PDLogger.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopdeemSDK.h"
#import <string.h>

#define __FILENAME__ (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)

#define PDLog(fmt, ...) \
[PDLogger logFilename:(__FILENAME__) line:(__LINE__) logContent:__VA_ARGS__]

#define PDLogError(fmt, ...) NSLog((@"❗️Popdeem Error:\n\tLocation: %s, Line %d\n\tMessage: " fmt), __FILENAME__, __LINE__, ##__VA_ARGS__)

@interface PDLogger : NSObject

+ (void) logFilename:(char*)filename line:(int)line logContent:(id)args;

@end
