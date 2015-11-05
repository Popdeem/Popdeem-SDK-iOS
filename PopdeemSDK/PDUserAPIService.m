//
//  PDUserAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDUserAPIService.h"
#import "PDAPIClient.h"

@implementation PDUserAPIService

- (id) init {
    if (self = [super init]) {
        return self;
    }
    return nil;
}

- (void) getUserDetailsForId:(NSString*)userId
         authenticationToken:(NSString*)authToken
                  completion:(void (^)(PDUser *user, NSError *error))completion {
    
    NSString *apiString = [NSString stringWithFormat:@"%@/%@/%@",self.baseUrl,USERS_PATH,userId];
    
    NSURLSession *session = [NSURLSession createPopdeemSession];
    [session GET:apiString
              params:nil
      completion:^(NSData* data, NSURLResponse *response, NSError *error) {
          if (error) {
              //Handle Error
              dispatch_async(dispatch_get_main_queue(), ^{
                  completion(nil, error);
              });
              return;
          }
          if (response) {
              //Deal with response
              NSError *jsonError;
              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
              
              PDUser *user = [PDUser initFromAPI:jsonObject[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
              [session invalidateAndCancel];
              dispatch_async(dispatch_get_main_queue(), ^{
                  completion(user, nil);
              });
          }
    }];
}

- (void) registerUserwithFacebookAccesstoken:(NSString*)facebookAccessToken
                                  facebookId:(NSString*)facebookId
                                  completion:(void (^)(PDUser *user, NSError *error))completion {
    
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
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return;
        }
        if (response) {
            //Deal with response
            NSError *jsonError;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
            PDUser *user = [PDUser initFromAPI:jsonObject[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
            [session invalidateAndCancel];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(user, nil);
            });
        }
    }];
}

- (void) updateUserWithCompletion:(void (^)(PDUser *user, NSError *error))completion {
    
    PDUser *_user = [PDUser sharedInstance];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"ios" forKey:@"user[platform]"];
    if ([[PDAPIClient sharedInstance] deviceToken]) {
        //Will be set by app delegate if user allows notifications
        [params setValue:[[PDAPIClient sharedInstance] deviceToken]  forKey:@"user[device_token]"];
        [_user setDeviceToken:[[PDAPIClient sharedInstance] deviceToken]];
    }
    [params setValue:[NSString stringWithFormat:@"%f",_user.lastLocation.latitude] forKey:@"user[latitude]"];
    [params setValue:[NSString stringWithFormat:@"%f",_user.lastLocation.longitude] forKey:@"user[longitude]"];
    
    NSString *putPath = [NSString stringWithFormat:@"%@/%@/%ld",self.baseUrl,USERS_PATH,(long)_user.identifier];
    NSURLSession *session = [NSURLSession createPopdeemSession];
    [session PUT:putPath params:params completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            //Handle Error
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return;
        }
        if (response) {
            //Deal with response
            NSError *jsonError;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
            PDUser *user = [PDUser initFromAPI:jsonObject[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
            [session invalidateAndCancel];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(user, nil);
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
