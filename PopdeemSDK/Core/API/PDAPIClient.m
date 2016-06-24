//
//  PDAPIClient.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDAPIClient.h"
#import "PDUserAPIService.h"
#import "PDSocialAPIService.h"
#import "PDLocationAPIService.h"
#import "PDBrandApiService.h"
#import "PDRewardAPIService.h"
#import "PDWalletAPIService.h"
#import "PDRewardActionAPIService.h"
#import "PDFeedAPIService.h"

@implementation PDAPIClient

+ (id) sharedInstance {
    static PDAPIClient *sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[PDAPIClient alloc] init];
    });
    return sharedClient;
}

#pragma mark - Get User Details -

- (void) getUserDetailsForId:(NSString*)userId
         authenticationToken:(NSString*)authToken
                      success:(void (^)(PDUser *user))success
                     failure:(void (^)(NSError *error))failure {
    
    PDUserAPIService *apiService = [[PDUserAPIService alloc] init];
    [apiService getUserDetailsForId:userId authenticationToken:authToken completion:^(PDUser *user, NSError *error){
        if (error) {
            failure(error);
        }
        if (user) {
            success(user);
        }
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
    
    PDUserAPIService *apiService = [[PDUserAPIService alloc] init];
    [apiService registerUserwithFacebookAccesstoken:facebookAccessToken facebookId:facebookId completion:^(PDUser *user, NSError *error){
        if (error) {
            failure(error);
        }
        if (user) {
            success(user);
        }
    }];
}

#pragma mark - Update User Location and DeviceToken -

- (void) updateUserLocationAndDeviceTokenSuccess:(void (^)(PDUser *user))success
                                         failure:(void (^)(NSError *error))failure {
    PDUserAPIService *apiService = [[PDUserAPIService alloc] init];
    [apiService updateUserWithCompletion:^(PDUser *user, NSError *error){
        if (error) {
            failure(error);
        }
        if (user) {
            success(user);
        }
    }];
}

#pragma mark - Connect Twitter Account - 

- (void) connectTwitterAccount:(NSString*)userId
                   accessToken:(NSString*)accessToken
                  accessSecret:(NSString*)accessSecret
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *error))failure {

    PDSocialAPIService *apiService = [[PDSocialAPIService alloc] init];
    [apiService connectTwitterAccount:userId accessToken:accessToken accessSecret:accessSecret completion:^(NSError *error){
        if (error) {
            failure(error);
        } else {
            success();
        }
    }];
}

#pragma mark - Connect Instagram Account -
- (void) connectInstagramAccount:(NSString*)userId
										 accessToken:(NSString*)accessToken
											screenName:(NSString*)screenName
												 success:(void (^)(void))success
												 failure:(void (^)(NSError *error))failure {
	PDSocialAPIService *service = [[PDSocialAPIService alloc] init];
	[service connectInstagramAccount:userId accessToken:accessToken screenName:screenName completion:^(NSError *error){
		if (error) {
			failure(error);
		} else {
			success();
		}
	}];
}

#pragma mark - Get All Locations -

- (void) getAllLocationsSuccess:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure {
    
    PDLocationAPIService *apiService = [[PDLocationAPIService alloc] init];
    [apiService getAllLocationsWithCompletion:^(NSError *error){
        if (error) {
            failure(error);
        }else {
            success();
        }
    }];
}

- (void) getLocationForId:(NSInteger)identifier
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure {
    
    PDLocationAPIService *apiService = [[PDLocationAPIService alloc] init];
    [apiService getLocationForId:identifier completion:^(NSError *error){
        if (error) {
            failure(error);
            return;
        }
        success();
    }];
}

- (void) getLocationsForBrandId:(NSInteger)brandId
                        success:(void (^)(void))success
                        failure:(void (^)(NSError *error))failure {
    PDLocationAPIService *apiService = [[PDLocationAPIService alloc] init];
    [apiService getLocationsForBrandId:brandId completion:^(NSError *error){
        if (error) {
            failure(error);
            return;
        }
        success();
    }];
}

#pragma mark - Get all Rewards

- (void) getAllRewardsSuccess:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure {
    
    PDRewardAPIService *apiService = [[PDRewardAPIService alloc] init];
    [apiService getAllRewardsWithCompletion:^(NSError *error){
        if (error) {
            failure(error);
            return ;
        }
        success();
    }];
}

- (void) getAllRewardsForLocationWithId:(NSInteger)locationIdentifier success:(void (^)(void))success
                                failure:(void (^)(NSError *error))failure {
    PDRewardAPIService *apiService = [[PDRewardAPIService alloc] init];
    [apiService getAllRewardsForLocationWithId:locationIdentifier completion:^(NSError *error){
        if (error) {
            failure(error);
            return ;
        }
        success();
    }];
}

- (void) getAllRewardsWithBundledBrandKeySuccess:(void (^)(void))success
                                         failure:(void (^)(NSError *error))failure {
//    NSString *bundledBrandKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"popdeemBrandKey"];
//    if (bundledBrandKey == nil) {
//        NSLog(@"Error: No popdeemBrandKey found in info.plist. Getting all rewards for customer instead");
//        [self getAllRewardsSuccess:success failure:failure];
//        return;
//    }
//    [self getAllRewardsByBrandKey:bundledBrandKey success:success failure:failure];
}

- (void) getAllRewardsByBrandKey:(NSString*)brandKey
                         success:(void (^)(void))success
                         failure:(void (^)(NSError *error))failure {
//    if (brandKey == nil) {
//        NSLog(@"Error: No Brand Key. Getting all rewards for customer instead");
//        [self getAllRewardsSuccess:success failure:failure];
//        return;
//    }
//    [self.requestSerializer setValue:brandKey forHTTPHeaderField:@"Brand-Key"];
//    [self getAllRewardsSuccess:success failure:failure];
    
}

- (void) getRewardsForBrandId:(NSInteger)brandid
                      success:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure {
    
    PDRewardAPIService *apiService = [[PDRewardAPIService alloc] init];
    [apiService getAllRewardsForBrandId:brandid completion:^(NSError *error){
        if (error) {
            failure(error);
            return ;
        }
        success();
    }];    
}

#pragma mark - Get all Wallet Rewards

- (void) getRewardsInWalletSuccess:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure {

    PDWalletAPIService *apiService = [[PDWalletAPIService alloc] init];
    [apiService getRewardsInWalletWithCompletion:^(NSError *error){
        if (error) {
            failure(error);
            return ;
        }
        success();
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
//    if (brandKey == nil) {
//        NSLog(@"Error: No Brand Key. Getting all rewards for customer instead");
//        [self getRewardsInWalletSuccess:success failure:failure];
//        return;
//    }
//    [self.requestSerializer setValue:brandKey forHTTPHeaderField:@"Brand-Key"];
//    [self getRewardsInWalletSuccess:success failure:failure];
}

#pragma mark - Claim Reward -

- (void) claimReward:(NSInteger)rewardId
            location:(PDLocation*)location
         withMessage:(NSString*)message
       taggedFriends:(NSArray*)taggedFriends
               image:(UIImage*)image
            facebook:(BOOL)facebook
             twitter:(BOOL)twitter
					 instagram:(BOOL)instagram
             success:(void (^)(void))success
             failure:(void (^)(NSError *error))failure {
    
    PDRewardActionAPIService *apiService = [[PDRewardActionAPIService alloc] init];
	[apiService claimReward:rewardId location:location withMessage:message taggedFriends:taggedFriends image:image facebook:facebook twitter:twitter instagram:instagram completion:^(NSError *error){
        if (error) {
            failure(error);
            return ;
        }
        success();
    }];
}

#pragma mark - Redeem Reward

- (void) redeemReward:(NSInteger)rewardId
              success:(void (^)(void))success
              failure:(void (^)(NSError *error))failure {
    
    PDRewardActionAPIService *apiService = [[PDRewardActionAPIService alloc] init];
    [apiService redeemReward:rewardId completion:^(NSError *error){
        if (error) {
            failure(error);
            return ;
        }
        success();
    }];
}

//- (void) redeemReward:(NSInteger)rewardId
// forUserWithAuthToken:(NSString*)authenticationToken
//              success:(void (^)(void))success
//              failure:(void (^)(NSError *error))failure {
//    
//    [[self requestSerializer] setValue:authenticationToken forKey:@"User-Token"];
//    NSString *postPath = [NSString stringWithFormat:@"%@/%ld/redeem",REWARDS_PATH,(long)rewardId];
//    
//    [self POST:postPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [PDWallet remove:rewardId];
//        success();
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                        @"Redeem Reward Failed", NSLocalizedDescriptionKey,
//                                        error, NSUnderlyingErrorKey,
//                                        nil];
//        NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
//                                                       code:PDErrorCodeClaimFailed
//                                                   userInfo:userDictionary];
//        failure(endError);
//    }];
//}

#pragma mark - Get Feeds -

- (void) getFeedsSuccess:(void (^)(void))success
                 failure:(void (^)(NSError *error))failure {
    
    PDFeedAPIService *apiService = [[PDFeedAPIService alloc] init];
    [apiService getFeedsLimit:20 completion:^(NSError *error){
        if (error) {
            failure(error);
            return ;
        }
        success();
    }];
}

#pragma mark - Get Brands -
-(void) getBrandsSuccess:(void (^)(void))success
                 failure:(void (^)(NSError *error))failure {
    
    PDBrandApiService *apiService = [[PDBrandApiService alloc] init];
    [apiService getBrandsWithCompletion:^(NSError *error){
        if (error) {
            failure(error);
            return;
        }
        success();
    }];
}

@end
