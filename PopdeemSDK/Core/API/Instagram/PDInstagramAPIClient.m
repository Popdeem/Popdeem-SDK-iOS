//
//  PDInstagramAPIClient.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDInstagramAPIClient.h"
#import "PDInstagramAPIService.h"

@implementation PDInstagramAPIClient

- (void) checkAccessToken:(void (^)(BOOL valid, NSError *error))completion {
	PDInstagramAPIService *service = [[PDInstagramAPIService alloc] init];
	[service checkAccessToken:^(BOOL valid, NSError *error){
		if (error) {
			completion(NO, error);
		}
		completion(valid, nil);
	}];
}

@end
