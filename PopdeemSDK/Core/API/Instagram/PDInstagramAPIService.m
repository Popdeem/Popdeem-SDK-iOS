//
//  PDInstagramAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDInstagramAPIService.h"
#import "PDConstants.h"

@implementation PDInstagramAPIService

- (id) init {
	if (self = [super init]) {
		self.baseUrl = INSTAGRAM_URL;
		return self;
	}
	return nil;
}

- (void) checkAccessToken:(void (^)(BOOL *valid, NSError *error))completion {
	
}

@end
