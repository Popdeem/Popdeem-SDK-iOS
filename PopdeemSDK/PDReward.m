//
//  PDReward.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDReward.h"
#import "PDUser.h"
#import "PDConstants.h"

@interface PDReward () {
    BOOL isDownloadingCover;
}

@end

@implementation PDReward

- (id) initFromApi:(NSDictionary*)params {
    if (self = [super init]) {
        self.identifier = [params[@"id"] integerValue];
        
        NSString *rewardType = params[@"reward_type"];
        if ([rewardType isEqualToString:@"sweepstake"]) {
            self.type = PDRewardTypeSweepstake;
        } else if ([rewardType isEqualToString:@"instant"]) {
            self.type = PDRewardTypeInstant;
        } else {
            self.type = PDRewardTypeCoupon;
        }
        
        //Wrap integers in NSNumber Values
        NSMutableArray *socMediaTypes = [NSMutableArray array];
        for (NSString *smt in params[@"social_media_types"]) {
            if ([smt isEqualToString:@"Facebook"]) {
                [socMediaTypes addObject:@(PDSocialMediaTypeFacebook)];
            }
            if ([smt isEqualToString:@"Twitter"]) {
                [socMediaTypes addObject:@(PDSocialMediaTypeTwitter)];
            }
            if ([smt isEqualToString:@"Instagram"]) {
                [socMediaTypes addObject:@(PDSocialMediaTypeInstagram)];
            }
        }
        self.socialMediaTypes = socMediaTypes;
        
        self.coverImageUrl = params[@"cover_image"];
        
        self.createdAt = [params[@"created_at"] intValue];
        
        self.rewardRules = params[@"rules"];
        
        self.rewardDescription = params[@"description"];
        
        NSString *status= params[@"status"];
        if ([status isEqualToString:@"live"]) {
            self.status = PDRewardStatusLive;
        } else if ([status isEqualToString:@"expired"]) {
            self.status = PDRewardStatusExpired;
        }
        
        NSMutableDictionary *actions = params[@"action"];
        NSString *facebookAction = actions[@"facebook"];
        NSString *twitterAction = actions[@"twitter"];
        if (facebookAction.length > 0) {
            if ([facebookAction isEqualToString:@"photo"]) {
                self.facebookAction = PDRewardActionPhoto;
            } else if ([facebookAction isEqualToString:@"checkin"]) {
                self.facebookAction = PDRewardActionCheckin;
            } else {
                self.facebookAction = PDRewardActionNone;
            }
        }
        if (twitterAction.length > 0) {
            if ([twitterAction isEqualToString:@"tweet"]) {
                self.twitterAction = PDRewardActionTweet;
            } else if ([twitterAction isEqualToString:@"photo"]) {
                self.twitterAction = PDRewardActionPhoto;
            } else {
                self.twitterAction = PDRewardActionNone;
            }
        }
        
        id remaining = params[@"remaining_count"];
        if ([remaining isKindOfClass:[NSString class]]) {
            if ([remaining isEqualToString:@"no limit"]) {
                self.remainingCount = PDREWARD_NO_LIMIT;
            }
        } else if ([remaining isKindOfClass:[NSNumber class]]) {
            self.remainingCount = [remaining longValue];
        }

        self.availableUntil = [params[@"available_until"] intValue];
        
        self.locationIds = [NSMutableArray array];
        
        return self;
    }
    return nil;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    return nil;
}

- (void) downloadCoverImageCompletion:(void (^)(BOOL success))completion {

    if (isDownloadingCover) completion(NO);
    
    if ([self.coverImageUrl isKindOfClass:[NSString class]]) {
        if ([self.coverImageUrl.lowercaseString rangeOfString:@"default"].location == NSNotFound) {
            isDownloadingCover = YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *coverData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.coverImageUrl]];
                UIImage *coverImage = [UIImage imageWithData:coverData];
                
                self.coverImage = coverImage;
                isDownloadingCover = NO;
                completion(YES);
            });
        } else {
            completion(NO);
        }
    }
}

@end
