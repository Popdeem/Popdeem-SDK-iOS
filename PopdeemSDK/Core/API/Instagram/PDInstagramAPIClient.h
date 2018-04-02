//
//  PDInstagramAPIClient.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLSession+Popdeem.h"

@interface PDInstagramAPIClient : NSObject

- (void) checkAccessToken:(void (^)(BOOL valid, NSError *error))completion;

@end
