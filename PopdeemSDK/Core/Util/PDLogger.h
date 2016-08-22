//
//  PDLogger.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PDLog(fmt) \
[[PDLogger sharedInstance] log:fmt]

#define PDLogError(fmt) \
[[PDLogger sharedInstance] logError:fmt]

#ifdef DEBUG
#   define PDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

@interface PDLogger : NSObject

+ (instancetype) sharedInstance;
- (void) log:(NSString*)fmt;
- (void) logError:(NSString*)fmt;

@end
