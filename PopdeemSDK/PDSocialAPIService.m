//
//  PDSocialAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDSocialAPIService.h"
#import "PDUser.h"

@implementation PDSocialAPIService

- (id) init {
    if (self = [super init]) {
        return self;
    }
    return nil;
}

- (void) connectTwitterAccount:(NSString*)userId
                   accessToken:(NSString*)accessToken
                  accessSecret:(NSString*)accessSecret
                    completion:(void (^)(NSError *error))completion {
    
    NSMutableDictionary *twitter = [NSMutableDictionary dictionary];
    [twitter setObject:userId forKey:@"social_id"];
    [twitter setObject:accessToken forKey:@"access_token"];
    [twitter setObject:accessSecret forKey:@"access_secret"];
    
    NSMutableDictionary *user = [NSMutableDictionary dictionary];
    [user setObject:twitter forKey:@"twitter"];
    [user setObject:[NSDictionary dictionary] forKey:@"facebook"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:user forKey:@"user"];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",self.baseUrl,USERS_PATH,@"connect_social_account"];
    NSURLSession *session = [NSURLSession createPopdeemSession];
    [session POST:path params:params completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(error);
            return;
        }
        NSError *jsonError;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        PDUser *user = [PDUser initFromAPI:jsonObject[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
        [user.twitterParams setAccessSecret:accessSecret];
        [session invalidateAndCancel];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil);
        });
    }];
}

- (void) disconnectTwitterAccountWithCompletion:(void (^)(NSError *error))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *user = [NSMutableDictionary dictionary];
    NSMutableDictionary *twitter = [NSMutableDictionary dictionary];
    NSString *twitterAccessToken = [[[PDUser sharedInstance] twitterParams] accessToken];
    NSString *twitterAccessSecret = [[[PDUser sharedInstance] twitterParams] accessSecret];
    [twitter setObject:twitterAccessToken forKey:@"access_token"];
    [twitter setObject:twitterAccessSecret forKey:@"access_secret"];
    [user setObject:twitter forKey:@"user"];
    [params setObject:user forKey:@"user"];
    
    NSURLSession *session = [NSURLSession createPopdeemSession];
    NSString *path = [NSString stringWithFormat:@"%@/%@/disconnect_social_account",self.baseUrl,USERS_PATH];
    [session POST:path params:params completion:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            completion(error);
            return;
        }
        completion(nil);
    }];
}

@end
