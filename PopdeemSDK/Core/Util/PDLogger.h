//
//  PDLogger.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PopdeemSDK.h"
#import <string.h>

#define __FILENAME__ (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)

#if DEBUG
#   define PDLog(fmt, ...) NSLog((@"Popdeem Debug Log:\n\tLocation: %s, Line %d\n\tMessage: " fmt), __FILENAME__, __LINE__, ##__VA_ARGS__)
#else
#   define PDLog(...)
#endif

#define PDLogError(fmt, ...) NSLog((@"❗️Popdeem Error:\n\tLocation: %s, Line %d\n\tMessage: " fmt), __FILENAME__, __LINE__, ##__VA_ARGS__)
