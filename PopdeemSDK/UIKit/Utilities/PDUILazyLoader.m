//
//  LazyLoader.m
//  Popdeem
//
//  Created by Niall Quinn on 23/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDUILazyLoader.h"
#import "PDBrand.h"
#import "PDBrandStore.h"
#import "PDReward.h"
#import "PDWallet.h"
#import "PDRewardStore.h"
#import "PDFeeds.h"
#import "PDMessageStore.h"


@implementation PDUILazyLoader

+ (void) loadBrandCoverImagesCompletion:(void (^)(BOOL success))completion {
    NSInteger count = [PDBrandStore count];
    __block NSInteger downloaded = 0;
    
    for (PDBrand *b in [PDBrandStore orderedByDistanceFromUser]) {
        if (!b.coverImage) {
            [b downloadCoverImageCompletion:^(BOOL success) {
                downloaded++;
                if (downloaded == count) {
                    completion(YES);
                }
            }];
        }
    }
}

+ (void) loadBrandLogoImagesCompletion:(void (^)(BOOL success))completion {
                                
    for (PDBrand *b in [PDBrandStore orderedByDistanceFromUser]) {
        if (!b.coverImage) {
            [b downloadLogoImageCompletion:^(BOOL success){
                completion(success);
            }];
        }
    }
}

+ (void) loadRewardCoverImagesForBrand:(NSInteger)identifier
                               completion:(void (^)(BOOL success))completion {
    for (PDReward *r in [PDRewardStore allRewardsForBrandId:identifier]) {
        if (!r.coverImage) {
            [r downloadCoverImageCompletion:^(BOOL success){
                completion(success);
            }];
        }
    }
}

+ (void) loadWalletRewardCoverImagesCompletion:(void (^)(BOOL success))completion {
    
    for (PDReward *r in [PDWallet wallet]) {
        if (!r.coverImage) {
            [r downloadCoverImageCompletion:^(BOOL success){
                completion(success);
            }];
        }
    }
}

+ (void) loadFeedImages {
    for (PDFeedItem *f in [PDFeeds feed]) {
        if (f.imageUrlString.length > 0 && f.actionImage == nil) {
            [f downloadActionImage];
        }
    }
}

+ (void) loadAllRewardCoverImagesCompletion:(void (^)(BOOL success))completion {
  for (PDReward *r in [PDRewardStore allRewards]) {
    if (!r.coverImage) {
      [r downloadCoverImageCompletion:^(BOOL success){
        completion(success);
      }];
    }
  }
}

+ (void) loadMessageImagesCompletion:(void (^)(BOOL success))completion {
  for (PDMessage *m in [PDMessageStore orderedByDate]) {
    [m downloadLogoImageCompletion:^(BOOL success){
      completion(success);
    }];
  }
}

@end
