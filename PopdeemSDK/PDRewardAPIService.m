//
//  PDRewardAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDRewardAPIService.h"
#import "PDReward.h"
#import "PDRewardStore.h"

@implementation PDRewardAPIService

-(id) init {
    if (self = [super init]) {
        return self;
    }
    return nil;
}

- (void) getAllRewardsWithCompletion:(void (^)(NSError *error))completion {
    
    NSURLSession *session = [NSURLSession createPopdeemSession];
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.baseUrl,REWARDS_PATH];
    [session GET:path params:nil completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
            return;
        }
        NSError *jsonError;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        for (id attributes in jsonObject[@"rewards"]) {
            for (NSDictionary *rew in attributes) {
                PDReward *reward = [[PDReward alloc] initFromApi:rew];
                [PDRewardStore add:reward];
            }
        }
        [session invalidateAndCancel];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil);
        });
    }];
}

- (void) getAllRewardsForLocationWithId:(NSInteger)locationIdentifier completion:(void (^)(NSError *error))completion {
    NSURLSession *session = [NSURLSession createPopdeemSession];
    NSString *path = [NSString stringWithFormat:@"%@/%@/%ld/rewards",self.baseUrl,LOCATIONS_PATH,(long)locationIdentifier];
    [session GET:path params:nil completion:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
            return;
        }
        NSError *jsonError;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        for (id attributes in jsonObject[@"rewards"]) {
            for (NSDictionary *rew in attributes) {
                PDReward *reward = [[PDReward alloc] initFromApi:rew];
                [PDRewardStore add:reward];
            }
        }
        [session invalidateAndCancel];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil);
        });
    }];
}

- (void) getAllRewardsForBrandId:(NSInteger)brandid completion:(void (^)(NSError *error))completion {
    NSURLSession *session = [NSURLSession createPopdeemSession];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/%ld/rewards",self.baseUrl,BRANDS_PATH,(long)brandid];
    [session GET:path params:nil completion:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
            return;
        }
        NSError *jsonError;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        for (NSDictionary *attributes in jsonObject) {
            PDReward *reward = [[PDReward alloc] initFromApi:attributes];
            reward.brandId = brandid;
            [PDRewardStore add:reward];
        }
        [session invalidateAndCancel];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil);
        });
    }];
}

@end
