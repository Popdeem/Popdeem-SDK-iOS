//
//  PDMomentAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 15/03/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDAPIService.h"

@interface PDMomentAPIService : PDAPIService

- (void) logMoment:(NSString*)momentString completion:(void (^)(NSError *error))completion;

@end
