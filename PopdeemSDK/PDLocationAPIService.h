//
//  PDLocationAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDAPIService.h"

@interface PDLocationAPIService : PDAPIService

- (void) getAllLocationsWithCompletion:(void (^)(NSError *error))completion;
- (void) getLocationForId:(NSInteger)identifier completion:(void (^)(NSError *error))completion;
- (void) getLocationsForBrandId:(NSInteger)brandId completion:(void (^)(NSError *error))completion;

@end
