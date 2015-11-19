//
//  NSURLSession+Popdeem.m
//  Pods
//
//  Created by Niall Quinn on 04/11/2015.
//
//

#import "NSURLSession+Popdeem.h"
#import "PDUser.h"
#import "PDUtils.h"
#import "PopdeemSDK.h"

@implementation NSURLSession (Popdeem)

+ (NSURLSession*) createPopdeemSession {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    return [[self class] sessionWithConfiguration:configuration];
}

+ (NSURLSession*) createWithConfiguration:(NSURLSessionConfiguration*)configuration {
    return [[self class] sessionWithConfiguration:configuration];
}

- (void) GET:(NSString*)apiString
      params:(NSDictionary*)params
  completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion {
    
    NSMutableURLRequest *mutableRequest = [self buildMutableRequestWithApiString:apiString params:params];
    [mutableRequest setHTTPMethod:@"GET"];

    NSURLSessionDataTask *getDataTask = [self dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        completion(data,response,error);
    }];
    [getDataTask resume];
}

- (void) POST:(NSString*)apiString
       params:(NSDictionary*)params
   completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion {
    
    NSMutableURLRequest *mutableRequest = [self buildMutableRequestWithApiString:apiString params:params];
    [mutableRequest setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *postDataTask = [self dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        completion(data,response,error);
    }];
    [postDataTask resume];
}

- (void) PUT:(NSString*)apiString
      params:(NSDictionary*)params
  completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion {
    
    NSMutableURLRequest *mutableRequest = [self buildMutableRequestWithApiString:apiString params:params];
    [mutableRequest setHTTPMethod:@"PUT"];
    
    NSURLSessionDataTask *putDataTask = [self dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        completion(data,response,error);
    }];
    [putDataTask resume];
}

- (NSMutableURLRequest*) buildMutableRequestWithApiString:(NSString*)apiString params:(NSDictionary*)params {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiString]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest addValue:[self apiKey] forHTTPHeaderField:@"Api-Key"];
    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if ([[PDUser sharedInstance] userToken]) {
        [mutableRequest addValue:[[PDUser sharedInstance] userToken] forHTTPHeaderField:@"User-Token"];
    }
    
    if (params) {
        NSError *jsonError;
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"Error creating JSON");
        }
        [mutableRequest setValue:[NSString stringWithFormat:@"%ld", [JSONData length]] forHTTPHeaderField:@"Content-Length"];
        [mutableRequest setHTTPBody:JSONData];
    }
    return mutableRequest;
}

- (NSString*) apiKey {
    PopdeemSDK *SDK = [PopdeemSDK sharedInstance];
    if (SDK.apiKey) return SDK.apiKey;
    //Search the plist
    NSString *apiKey;
    NSError *err;
    apiKey = [PDUtils getPopdeemApiKey:&err];
    if (err) {
        [NSException raise:@"No API Key" format:@"%@",err.localizedDescription];
    }
    return apiKey;
}
@end
