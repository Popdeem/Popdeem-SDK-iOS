//
//  PDBackgroundScan.h
//  PopdeemSDK
//
//  Created by niall quinn on 30/03/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDAPIService.h"
#import "PDReward.h"

@interface PDBackgroundScan : PDAPIService

- (void) scanNetwork:(NSString*)network
              reward:(PDReward *)reward
             success:(void (^)(BOOL isValidated))success
             failure:(void (^)(NSError *error))failure;

@end
