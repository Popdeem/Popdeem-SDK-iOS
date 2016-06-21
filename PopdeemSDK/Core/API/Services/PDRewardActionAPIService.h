//
//  PDRewardActionAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDAPIService.h"
#import "PDLocation.h"
#import <UIKit/UIKit.h>

@interface PDRewardActionAPIService : PDAPIService

- (void) claimReward:(NSInteger)rewardId
            location:(PDLocation*)location
         withMessage:(NSString*)message
       taggedFriends:(NSArray*)taggedFriends
               image:(UIImage*)image
            facebook:(BOOL)facebook
             twitter:(BOOL)twitter
					 instagram:(BOOL)instagram
          completion:(void (^)(NSError *error))completion;


- (void) redeemReward:(NSInteger)rewardId
           completion:(void (^)(NSError *error))completion;

@end
