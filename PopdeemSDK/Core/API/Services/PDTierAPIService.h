//
//  PDTierAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 01/03/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDAPIService.h"
#import "PDTierEvent.h"

@interface PDTierAPIService : PDAPIService

- (void) reportTierAsRead:(PDTierEvent*)tier completion:(void (^)(NSError *error))completion;

@end
