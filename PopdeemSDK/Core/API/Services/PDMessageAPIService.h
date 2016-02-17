//
//  PDMessageAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/12/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDAPIService.h"

@interface PDMessageAPIService : PDAPIService

- (void) markMessageAsRead:(NSInteger)messageId
                completion:(void (^)(NSError *error))completion;
- (void) fetchMessagesCompletion:(void (^)(NSArray *messages, NSError *error))completion;

@end
