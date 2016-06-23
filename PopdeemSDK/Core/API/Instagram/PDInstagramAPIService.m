//
//  PDInstagramAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDInstagramAPIService.h"
#import "PDConstants.h"
#import "NSURLSession+Popdeem.h"
#import "PDUser.h"

@implementation PDInstagramAPIService

- (id) init {
	if (self = [super init]) {
		self.baseUrl = INSTAGRAM_URL;
		return self;
	}
	return nil;
}

- (void) checkAccessToken:(void (^)(BOOL valid, NSError *error))completion {
	NSURLSession *session = [NSURLSession createPopdeemSession];
	PDUser *user = [PDUser sharedInstance];
	NSString *path = [NSString stringWithFormat:@"%@/users/self/?access_token=%@", self.baseUrl, user.instagramParams.accessToken];
	[session GET:path params:nil completion:^(NSData *data, NSURLResponse *response, NSError *error){
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(NO, error);
			});
		}
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		NSInteger responseStatusCode = [httpResponse statusCode];
		BOOL ok = (responseStatusCode == 200);
		NSError *jsonError;
		NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
		completion(ok, error);
	}];
}

- (void) resolveInstagramParamsOnUser:(NSDictionary*)params {
	
}

@end
