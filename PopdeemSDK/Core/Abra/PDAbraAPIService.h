//
//  PDAbraAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/09/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLSession+Abra.h"

@interface PDAbraAPIService : NSObject

- (void) onboardUser;
- (void) logEvent:(NSString*)eventName properties:(NSDictionary*)properties;

@end
