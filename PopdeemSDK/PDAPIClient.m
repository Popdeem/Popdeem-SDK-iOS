//
//  PDAPIClient.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDAPIClient.h"

@implementation PDAPIClient

+ (id) sharedInstance {
    static PDAPIClient *sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[PDAPIClient alloc] initWithBaseURL:[NSURL URLWithString:API_URL]];
    });
    return sharedClient;
}

- (NSString*) apiKey {
    NSError *err;
    NSString *apiKey = [PDUtils getPopdeemApiKey:&err];
    if (err) {
        [NSException raise:@"No API Key" format:@"%@",err.localizedDescription];
    }
    return apiKey;
}

- (id) initWithBaseURL:(NSURL*)baseURL {
    if (self = [super initWithBaseURL:baseURL]) {
        //Serialize request as plain HHTP
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.requestSerializer.timeoutInterval = 120;
        //Serialize response as JSON
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        //Set the apikey in the header
        [self.requestSerializer setValue:[self apiKey] forHTTPHeaderField:@"Api-Key"];
        return self;
    }
    return nil;
}

#pragma mark - Get User Details -

- (void) getUserDetailsForId:(NSString*)userId
         authenticationToken:(NSString*)authToken
                      success:(void (^)(PDUser *user))success
                     failure:(void (^)(NSError *error))failure {
    
    NSString *getPath = [NSString stringWithFormat:@"%@/%@",USERS_PATH,userId];
    [self.requestSerializer setValue:authToken forHTTPHeaderField:@"User-Token"];
    
    [self GET:getPath
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSDictionary *userObject = responseObject[@"user"];
          PDUser *u = [PDUser initFromAPI:userObject preferredSocialMediaType:PDSocialMediaTypeFacebook];
          success(u);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"User creation from API Failed", NSLocalizedDescriptionKey,
                                          error, NSUnderlyingErrorKey,
                                          nil];
          NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                         code:PDErrorCodeUserCreationFailed
                                                     userInfo:userDictionary];
          failure(endError);
      }];
}

#pragma mark - Facebook -
/*
 Register a user using facebook access token and facebook id
 */

- (void) registerUserwithFacebookAccesstoken:(NSString*)facebookAccessToken
                                  facebookId:(NSString*)facebookId
                                      success:(void (^)(PDUser *user))success
                                     failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *facebook = [NSMutableDictionary dictionary];
    [facebook setObject:facebookId forKey:@"id"];
    [facebook setObject:facebookAccessToken forKey:@"access_token"];
    
    NSMutableDictionary *user = [NSMutableDictionary dictionary];
    [user setObject:facebook forKey:@"facebook"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:user forKey:@"user"];
    
    [self POST:USERS_PATH
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
           NSDictionary *userObject = responseObject[@"user"];
           PDUser *user = [PDUser initFromAPI:userObject preferredSocialMediaType:PDSocialMediaTypeFacebook];
           [user.facebookParams setAccessToken:facebookAccessToken];
           [user.facebookParams setIdentifier:facebookId];
           success(user);
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @"User Registration Failed", NSLocalizedDescriptionKey,
                                           error, NSUnderlyingErrorKey,
                                           nil];
           NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                          code:PDErrorCodeUserCreationFailed
                                                      userInfo:userDictionary];
           failure(endError);
       }];
}

#pragma mark - Update User Location and DeviceToken -

- (void) updateUserLocationAndDeviceTokenSuccess:(void (^)(PDUser *user))success
                                        failure:(void (^)(NSError *error))failure {
    
    PDUser *_user = [PDUser sharedInstance];
    [self.requestSerializer setValue:_user.userToken forHTTPHeaderField:@"User-Token"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"ios" forKey:@"user[platform]"];
    if (_deviceToken) {
        //Will be set by app delegate if user allows notifications
        [params setValue:_deviceToken  forKey:@"user[device_token]"];
        [_user setDeviceToken:_deviceToken];
    }
    [params setValue:[NSString stringWithFormat:@"%f",_user.lastLocation.latitude] forKey:@"user[latitude]"];
    [params setValue:[NSString stringWithFormat:@"%f",_user.lastLocation.longitude] forKey:@"user[longitude]"];
    
    NSString *putPath = [NSString stringWithFormat:@"%@/%li",USERS_PATH,_user.identifier];
    
    [self PUT:putPath
   parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [PDUser initFromAPI:[responseObject objectForKey:@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
          success(_user);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"User Update Failed", NSLocalizedDescriptionKey,
                                          error, NSUnderlyingErrorKey,
                                          nil];
          NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                         code:PDErrorCodeUserCreationFailed
                                                     userInfo:userDictionary];
          failure(endError);
      }
     ];
}

#pragma mark - Get All Locations -

- (void) getAllLocationsSuccess:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure {
    PDUser *_user = [PDUser sharedInstance];
    [self.requestSerializer setValue:_user.userToken forHTTPHeaderField:@"User-Token"];
    [self POST:LOCATIONS_PATH
    parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           for (id loc in responseObject[@"locations"]) {
               PDLocation *location = [[PDLocation alloc] initFromApi:loc];
               [PDLocationStore add:location];
           }
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @"Get Locations Failed", NSLocalizedDescriptionKey,
                                           error, NSUnderlyingErrorKey,
                                           nil];
           NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                          code:PDErrorCodeGetLocationsFailed
                                                      userInfo:userDictionary];
           failure(endError);
       }];
}

- (void) getLocationForId:(NSInteger)identifier
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure {
    PDUser *_user = [PDUser sharedInstance];
    [self.requestSerializer setValue:_user.userToken forHTTPHeaderField:@"User-Token"];
    NSString *singleLocationPath = [NSString stringWithFormat:@"%@/%li",LOCATIONS_PATH,identifier];
    [self POST:singleLocationPath
    parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {

            PDLocation *location = [[PDLocation alloc] initFromApi:responseObject[@"location"]];
            [PDLocationStore add:location];
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @"Get Locations Failed", NSLocalizedDescriptionKey,
                                           error, NSUnderlyingErrorKey,
                                           nil];
           NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                          code:PDErrorCodeGetLocationsFailed
                                                      userInfo:userDictionary];
           failure(endError);
       }];
}

#pragma mark - Get all Rewards

- (void) getAllRewardsSuccess:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure {
    
    PDUser *_user = [PDUser sharedInstance];
    [self.requestSerializer setValue:_user.userToken forHTTPHeaderField:@"User-Token"];
    
    [self GET:REWARDS_PATH
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSDictionary *rewardsObj = [responseObject valueForKeyPath:@"rewards"];
          [PDRewardStore removeAllRewards];
          for (NSDictionary *attributes in rewardsObj) {
              PDReward *reward = [[PDReward alloc] initFromApi:attributes];
              [PDRewardStore add:reward];
          }
          
          success();
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"Get All Rewards Failed", NSLocalizedDescriptionKey,
                                          error, NSUnderlyingErrorKey,
                                          nil];
          NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                         code:PDErrorCodeGetLocationsFailed
                                                     userInfo:userDictionary];
          failure(endError);
          
      }];
}

- (void) getAllRewardsForLocationWithId:(NSInteger)locationIdentifier success:(void (^)(void))success
                                failure:(void (^)(NSError *error))failure {
    PDUser *_user = [PDUser sharedInstance];
    [self.requestSerializer setValue:_user.userToken forHTTPHeaderField:@"User-Token"];
    NSString *singleLocationRewardsPath = [NSString stringWithFormat:@"%@/%li/rewards",LOCATIONS_PATH,locationIdentifier];
    [self GET:singleLocationRewardsPath
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSDictionary *rewardsObj = [responseObject valueForKeyPath:@"rewards"];
          for (PDReward *r in [PDRewardStore store]) {
              if ([r.locationIds containsObject:@(locationIdentifier)]) {
                  [[PDRewardStore store] removeObject:r];
              }
          }
          for (NSDictionary *attributes in rewardsObj) {
              PDReward *reward = [[PDReward alloc] initFromApi:attributes];
              [PDRewardStore add:reward];
          }
          
          success();
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"Get All Rewards Failed", NSLocalizedDescriptionKey,
                                          error, NSUnderlyingErrorKey,
                                          nil];
          NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                         code:PDErrorCodeGetLocationsFailed
                                                     userInfo:userDictionary];
          failure(endError);
          
      }];
}

- (void) getAllRewardsWithBundledBrandKeySuccess:(void (^)(void))success
                                         failure:(void (^)(NSError *error))failure {
    NSString *bundledBrandKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"popdeemBrandKey"];
    if (bundledBrandKey == nil) {
        NSLog(@"Error: No popdeemBrandKey found in info.plist. Getting all rewards for customer instead");
        [self getAllRewardsSuccess:success failure:failure];
        return;
    }
    [self getAllRewardsByBrandKey:bundledBrandKey success:success failure:failure];
}

- (void) getAllRewardsByBrandKey:(NSString*)brandKey
                         success:(void (^)(void))success
                         failure:(void (^)(NSError *error))failure {
    if (brandKey == nil) {
        NSLog(@"Error: No Brand Key. Getting all rewards for customer instead");
        [self getAllRewardsSuccess:success failure:failure];
        return;
    }
    [self.requestSerializer setValue:brandKey forHTTPHeaderField:@"Brand-Key"];
    [self getAllRewardsSuccess:success failure:failure];
    
}

#pragma mark - Get all Wallet Rewards

- (void) getRewardsInWalletSuccess:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure {
    PDUser *_user = [PDUser sharedInstance];
    [self.requestSerializer setValue:_user.userToken forHTTPHeaderField:@"User-Token"];
    
    [self GET:WALLET_PATH
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSDictionary *rewardsObj = [responseObject valueForKeyPath:@"rewards"];
          [PDWallet removeAllRewards];
          for (NSDictionary *attributes in rewardsObj) {
              PDReward *reward = [[PDReward alloc] initFromApi:attributes];
              if (reward.status == PDRewardStatusLive) {
                  [PDWallet add:reward];
              }
          }
          success();
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"Get All Rewards Failed", NSLocalizedDescriptionKey,
                                          error, NSUnderlyingErrorKey,
                                          nil];
          NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                         code:PDErrorCodeGetLocationsFailed
                                                     userInfo:userDictionary];
          failure(endError);
      }];
}

- (void) getAllWalletRewardsWithBundledBrandKeySuccess:(void (^)(void))success
                                               failure:(void (^)(NSError *error))failure {
    NSString *bundledBrandKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"popdeemBrandKey"];
    if (bundledBrandKey == nil) {
        NSLog(@"Error: No popdeemBrandKey found in info.plist. Getting all rewards for customer instead");
        [self getRewardsInWalletSuccess:success failure:failure];
        return;
    }
    [self getAllWalletRewardsByBrandKey:bundledBrandKey success:success failure:failure];
}

- (void) getAllWalletRewardsByBrandKey:(NSString*)brandKey
                               success:(void (^)(void))success
                               failure:(void (^)(NSError *error))failure {
    if (brandKey == nil) {
        NSLog(@"Error: No Brand Key. Getting all rewards for customer instead");
        [self getRewardsInWalletSuccess:success failure:failure];
        return;
    }
    [self.requestSerializer setValue:brandKey forHTTPHeaderField:@"Brand-Key"];
    [self getRewardsInWalletSuccess:success failure:failure];
}

#pragma mark - Claim Reward -

- (void) claimReward:(NSInteger)rewardId
         withMessage:(NSString*)message
       taggedFriends:(NSArray*)taggedFriends
               image:(UIImage*)image
             success:(void (^)(void))success
             failure:(void (^)(NSError *error))failure {
    
    PDUser *_user = [PDUser sharedInstance];
    NSString *postPath = [NSString stringWithFormat:@"%@/%li/claim",REWARDS_PATH,rewardId];
    
    PDReward *r = [PDRewardStore find:rewardId];
    
    //Build headers
    [[self requestSerializer] setValue:_user.userToken forHTTPHeaderField:@"User-Token"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (message) {
        [params setObject:message forKey:@"message"];
    }
    if (image) {
        NSString *imageString = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:0];
        [params setObject:imageString forKey:@"file"];
    } else if (r.action == PDRewardActionPhoto) {
        //There must be a photo on this action
        NSLog(@"The reward action specifies PDRewardActionPhoto, but there is no image attached. Cannot claim this reward...Aborting");
        NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"The reward action specifies PDRewardActionPhoto, but there is no image attached. Cannot claim this reward...", NSLocalizedDescriptionKey,
                                        nil];
        NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                       code:PDErrorCodeClaimFailed
                                                   userInfo:userDictionary];
        failure(endError);
        return;
    }
    
    if ([[PDUser sharedInstance] preferredSocialMediaType] == PDSocialMediaTypeFacebook) {
        NSMutableDictionary *facebookParams = [NSMutableDictionary dictionary];
        [facebookParams setObject:_user.facebookParams.accessToken forKey:@"access_token"];
        if (taggedFriends.count > 0) {
            [facebookParams setObject:_user.selectedFriendsJSONRepresentation  forKey:@"associated_account_ids"];
        }
        [params setObject:facebookParams forKey:@"facebook"];
    } else if ([[PDUser sharedInstance] preferredSocialMediaType] == PDSocialMediaTypeTwitter) {
        
    }
    
    if (image) {
        NSString *imageString = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:0];
        [params setObject:imageString forKey:@"file"];
    }
    
    NSDictionary *locationParams = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.4f",_user.lastLocation.latitude],@"latitude",[NSString stringWithFormat:@"%.4f",_user.lastLocation.longitude], @"longitude", nil];
    [params setObject:locationParams forKey:@"location"];
    
    NSLog(@"Claim");
    [self POST:postPath
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           success();
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @"Claim Reward Failed", NSLocalizedDescriptionKey,
                                           error, NSUnderlyingErrorKey,
                                           nil];
           NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                          code:PDErrorCodeClaimFailed
                                                      userInfo:userDictionary];
           failure(endError);
       }];
}

#pragma mark - Redeem Reward

- (void) redeemReward:(NSInteger)rewardId
              success:(void (^)(void))success
              failure:(void (^)(NSError *error))failure {
    
    PDUser *_user = [PDUser sharedInstance];
    [[self requestSerializer] setValue:_user.userToken forHTTPHeaderField:@"User-Token"];
    
    NSString *postPath = [NSString stringWithFormat:@"%@/%li/redeem",REWARDS_PATH,rewardId];
    [self POST:postPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [PDWallet remove:rewardId];
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"Redeem Reward Failed", NSLocalizedDescriptionKey,
                                        error, NSUnderlyingErrorKey,
                                        nil];
        NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                       code:PDErrorCodeClaimFailed
                                                   userInfo:userDictionary];
        failure(endError);
    }];
}

- (void) redeemReward:(NSInteger)rewardId
 forUserWithAuthToken:(NSString*)authenticationToken
              success:(void (^)(void))success
              failure:(void (^)(NSError *error))failure {
    
    [[self requestSerializer] setValue:authenticationToken forKey:@"User-Token"];
    NSString *postPath = [NSString stringWithFormat:@"%@/%li/redeem",REWARDS_PATH,rewardId];
    
    [self POST:postPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [PDWallet remove:rewardId];
        success();
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"Redeem Reward Failed", NSLocalizedDescriptionKey,
                                        error, NSUnderlyingErrorKey,
                                        nil];
        NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                       code:PDErrorCodeClaimFailed
                                                   userInfo:userDictionary];
        failure(endError);
    }];
}

#pragma mark - Get Feeds -

- (void) getFeedsSuccess:(void (^)(void))success
                 failure:(void (^)(NSError *error))failure {
    
    PDUser *user = [PDUser sharedInstance];
    [[self requestSerializer] setValue:user.userToken forHTTPHeaderField:@"User-Token"];
    
    [self GET:FEEDS_PATH parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *feeds = [responseObject objectForKey:@"feeds"];
        [PDFeeds populateFromAPI:feeds];
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"Get Feeds Failed", NSLocalizedDescriptionKey,
                                        error, NSUnderlyingErrorKey,
                                        nil];
        NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                       code:PDErrorCodeGetFeedsFailed
                                                   userInfo:userDictionary];
        failure(endError);
    }];
}

@end
