//
//  PDAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDAPIService.h"
#import "PopdeemSDK.h"

@implementation PDAPIService

- (id) init {
    if (self = [super init]) {
        self.baseUrl = [[PopdeemSDK sharedInstance] apiURL];
        return self;
    }
    return nil;
}

@end
