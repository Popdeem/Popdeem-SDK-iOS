//
//  LazyLoader.h
//  Popdeem
//
//  Created by Niall Quinn on 23/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDUILazyLoader : NSObject

+ (void) loadBrandCoverImagesCompletion:(void (^)(BOOL success))completion;

+ (void) loadBrandLogoImagesCompletion:(void (^)(BOOL success))completion;

+ (void) loadRewardCoverImagesForBrand:(NSInteger)identifier
                            completion:(void (^)(BOOL success))completion;

+ (void) loadWalletRewardCoverImagesCompletion:(void (^)(BOOL success))completion;

+ (void) loadFeedImages;

+ (void) loadAllRewardCoverImagesCompletion:(void (^)(BOOL success))completion;

+ (void) loadMessageImagesCompletion:(void (^)(BOOL success))completion;
@end
