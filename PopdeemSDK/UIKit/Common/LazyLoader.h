//
//  LazyLoader.h
//  Pods
//
//  Created by Niall Quinn on 09/12/2015.
//
//

#import <Foundation/Foundation.h>

@interface LazyLoader : NSObject

+ (void) loadBrandCoverImagesCompletion:(void (^)(BOOL success))completion;

+ (void) loadBrandLogoImagesCompletion:(void (^)(BOOL success))completion;

+ (void) loadRewardCoverImagesForBrand:(NSInteger)identifier
                            completion:(void (^)(BOOL success))completion;

+ (void) loadWalletRewardCoverImagesCompletion:(void (^)(BOOL success))completion;

+ (void) loadFeedImages;

+ (void) loadAllRewardCoverImagesCompletion:(void (^)(BOOL success))completion;
@end
