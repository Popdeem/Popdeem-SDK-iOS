//
//  PDAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDConstants.h"
#import "NSURLSession+Popdeem.h"
#import "PDConstants.h"
#import "PDNetworkError.h"

@interface PDAPIService : NSObject

@property (nonatomic, strong) NSString *baseUrl;

@end
