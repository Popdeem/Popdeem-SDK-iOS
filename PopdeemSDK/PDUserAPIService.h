//
//  PDUserAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDAPIService.h"
#import "PDUser.h"

@interface PDUserAPIService : PDAPIService

@property (nonatomic, strong) NSString *baseUrl;

- (id) init;
- (void) getUserDetailsForId:(NSString*)userId
         authenticationToken:(NSString*)authToken
                     success:(void (^)(PDUser *user))success
                     failure:(void (^)(NSError *error))failure;

@end
