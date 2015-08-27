//
//  PDWallet.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDReward.h"

@interface PDWallet : NSObject

+ (NSMutableArray *) wallet;
+ (PDReward*) find:(NSInteger)identifier;
+ (void) add:(PDReward*)reward;
+ (void) remove:(NSInteger)rewardId;
+ (void) removeAllRewards;

@end
