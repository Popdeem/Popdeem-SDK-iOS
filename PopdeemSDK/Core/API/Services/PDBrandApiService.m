//
//  PDBrandApiService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDBrandApiService.h"
#import "PDBrandStore.h"
#import "PDLogger.h"

@implementation PDBrandApiService

-(id) init {
  if (self = [super init]) {
    return self;
  }
  return nil;
}

- (void) getBrandsWithCompletion:(void (^)(NSError *error))completion {
  
  NSURLSession *session = [NSURLSession createPopdeemSession];
  NSString *path = [NSString stringWithFormat:@"%@/%@",self.baseUrl,BRANDS_PATH];
  [session GET:path params:nil completion:^(NSData *data, NSURLResponse *response, NSError *error){
    if (error) {
      dispatch_async(dispatch_get_main_queue(), ^{
				PDLogAlert(@"%@",error.localizedDescription);
        completion(error);
      });
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode < 500) {
      NSError *jsonError;
      NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
			if (jsonError) {
				PDLogAlert(@"%@", [jsonError localizedDescription]);
				completion(jsonError);
				return ;
			}
      if (!jsonObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
          completion([NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
        });
        return;
      }
      for (id attributes in jsonObject[@"brands"]) {
        PDBrand *b = [[PDBrand alloc] initFromApi:attributes];
        if ([PDBrandStore findBrandByIdentifier:b.identifier] == nil) {
          [PDBrandStore add:b];
        } else {
          [[PDBrandStore findBrandByIdentifier:b.identifier] setNumberOfRewardsAvailable:b.numberOfRewardsAvailable];
        }
      }
      [session invalidateAndCancel];
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil);
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
				PDLogAlert(@"Response Code: %li",responseStatusCode);
        completion([PDNetworkError errorForStatusCode:responseStatusCode]);
      });
    }
  }];
}

- (void) getBrandByVendorSearchTerm:(NSString*)vendorSearchTerm completion:(void (^)(PDBrand *b, NSError *error))completion {
	NSURLSession *session = [NSURLSession createPopdeemSession];
	NSString *path = [NSString stringWithFormat:@"%@/%@/%@",self.baseUrl,BRANDS_PATH,vendorSearchTerm];
	[session GET:path params:nil completion:^(NSData *data, NSURLResponse *response, NSError *error){
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				PDLogAlert(@"%@",error.localizedDescription);
				completion(nil, error);
			});
		}
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		NSInteger responseStatusCode = [httpResponse statusCode];
		if (responseStatusCode < 500) {
			NSError *jsonError;
			NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
			if (jsonError) {
				PDLogAlert(@"%@", [jsonError localizedDescription]);
				completion(nil,jsonError);
				return ;
			}
			if (!jsonObject) {
				dispatch_async(dispatch_get_main_queue(), ^{
					completion(nil, [NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
				});
				return;
			}
			id brand = jsonObject[@"brand"];
			if (!brand) {
				dispatch_async(dispatch_get_main_queue(), ^{
					completion(nil, [NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
				});
				return;
			}
			PDBrand *b = [[PDBrand alloc] initFromApi:brand];
			[session invalidateAndCancel];
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(b, nil);
			});
		} else {
			dispatch_async(dispatch_get_main_queue(), ^{
				PDLogAlert(@"Response Code: %li",responseStatusCode);
				completion(nil, [PDNetworkError errorForStatusCode:responseStatusCode]);
			});
		}
	}];
}

@end
