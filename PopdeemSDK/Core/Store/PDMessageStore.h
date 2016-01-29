//
//  PDMessageStore.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDMessage.h"

@interface PDMessageStore : NSObject

+ (NSMutableDictionary*) store;
+ (void) add:(PDMessage*)message;
+ (NSArray*) orderedByDate;
+ (void) removeAllObjects;
@end
