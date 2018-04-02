//
//  PDBrandApiService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDAPIService.h"
#import "PDBrand.h"

@interface PDBrandApiService : PDAPIService

- (void) getBrandsWithCompletion:(void (^)(NSError *error))completion;
- (void) getBrandByVendorSearchTerm:(NSString*)vendorSearchTerm completion:(void (^)(PDBrand *b, NSError *error))completion;

@end
