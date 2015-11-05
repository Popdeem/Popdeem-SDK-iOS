//
//  PDBrandApiService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDAPIService.h"

@interface PDBrandApiService : PDAPIService

- (void) getBrandsWithCompletion:(void (^)(NSError *error))completion;

@end
