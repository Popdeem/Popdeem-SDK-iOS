//
//  PDFeedAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDAPIService.h"

@interface PDFeedAPIService : PDAPIService

- (void) getFeedsWithCompletion:(void (^)(NSError *error))completion;
- (void) getFeedsLimit:(NSInteger)limit completion:(void (^)(NSError *error))completion;

@end
