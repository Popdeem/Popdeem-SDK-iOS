//
//  PDURLSession.m
//  Pods
//
//  Created by Niall Quinn on 04/11/2015.
//
//

#import "PDURLSession.h"
#import "PDUtils.h"
#import "PDUser.h"

@implementation PDURLSession



+ (id) create {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    return [PDURLSession createWithConfiguration:configuration];
}

+ (id) createWithConfiguration:(NSURLSessionConfiguration*)configuration {
    return [PDURLSession sessionWithConfiguration:configuration];
}

- (void) GETRequest:(NSURLRequest *)request
             params:(NSDictionary*)params
  completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completion {
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest addValue:[self apiKey] forHTTPHeaderField:@"Api-Key"];
    if ([[PDUser sharedInstance] userToken]) {
        [mutableRequest addValue:[[PDUser sharedInstance] userToken] forHTTPHeaderField:@"User-Token"];
    }
    [mutableRequest setHTTPMethod:@"GET"];
    
    if (params) {
        NSError *jsonError;
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"Error creating JSON");
        }
        [mutableRequest setValue:[NSString stringWithFormat:@"%ld", [JSONData length]] forHTTPHeaderField:@"Content-Length"];
        [mutableRequest setHTTPBody:JSONData];
    }
    
    NSURLSessionDataTask *postDataTask = [self dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        completion(data,response,error);
        [self invalidateAndCancel];
    }];
    [postDataTask resume];
}

- (NSString*) apiKey {
    NSError *err;
    NSString *apiKey = [PDUtils getPopdeemApiKey:&err];
    if (err) {
        [NSException raise:@"No API Key" format:@"%@",err.localizedDescription];
    }
    return apiKey;
}
@end
