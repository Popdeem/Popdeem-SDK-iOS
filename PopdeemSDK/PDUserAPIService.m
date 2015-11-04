//
//  PDUserAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDUserAPIService.h"
#import "PDConstants.h"
#import "PDUtils.h"
#import "PDURLSession.h"
#import "NSURLSession+Popdeem.h"

@implementation PDUserAPIService

- (id) init;
{
    if (self = [super init]) {
        self.baseUrl = API_URL;
        return self;
    }
    return nil;
}

- (void) getUserDetailsForId:(NSString*)userId
         authenticationToken:(NSString*)authToken
                     success:(void (^)(PDUser *user))success
                     failure:(void (^)(NSError *error))failure {
    
    NSString *apiString = [NSString stringWithFormat:@"%@/%@/%@",self.baseUrl,USERS_PATH,userId];
    
    NSURLSession *session = [NSURLSession createPopdeemSession];
    [session GET:apiString
              params:nil
      completion:^(NSData* data, NSURLResponse *response, NSError *error) {
          if (error) {
              //Handle Error
              failure(error);
              return;
          }
          if (response) {
              //Deal with response
              NSError *jsonError;
              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
              
              PDUser *user = [PDUser initFromAPI:jsonObject[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
              [session invalidateAndCancel];
              dispatch_async(dispatch_get_main_queue(), ^{
                  success(user);
              });
          }
    }];
}

- (void) registerUserwithFacebookAccesstoken:(NSString*)facebookAccessToken
                                  facebookId:(NSString*)facebookId
                                     success:(void (^)(PDUser *user))success
                                     failure:(void (^)(NSError *error))failure {
    
    NSString *apiString = [NSString stringWithFormat:@"%@/%@",self.baseUrl,USERS_PATH];
    
    NSMutableDictionary *facebook = [NSMutableDictionary dictionary];
    [facebook setObject:facebookId forKey:@"id"];
    [facebook setObject:facebookAccessToken forKey:@"access_token"];
    
    NSMutableDictionary *user = [NSMutableDictionary dictionary];
    [user setObject:facebook forKey:@"facebook"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:user forKey:@"user"];
    
    NSURLSession *session = [NSURLSession createPopdeemSession];
    [session POST:apiString params:params completion:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            //Handle Error
            failure(error);
            return;
        }
        if (response) {
            //Deal with response
            NSError *jsonError;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
            PDUser *user = [PDUser initFromAPI:jsonObject[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
            [session invalidateAndCancel];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(user);
            });
        }
    }];
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
