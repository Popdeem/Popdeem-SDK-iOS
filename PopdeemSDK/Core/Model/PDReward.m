//
//  PDReward.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDReward.h"
#import "PDUser.h"

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
        
        NSString *action = [params[@"action"] isKindOfClass:[NSString class]] ? params[@"action"] : @"";
        if ([action isEqualToString:@"photo"]) {
            self.action = PDRewardActionPhoto;
        } else if ([action isEqualToString:@"checkin"]) {
            self.action = PDRewardActionCheckin;
        } else {
            self.action = PDRewardActionNone;
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
        /*
        "tweet_options" =     {
            "download_link" = "http://bit.ly/1iIe5Q3";
            "force_tag" = true;
            "forced_tag" = "#forcedTag";
            "free_form" = false;
            "include_download_link" = true;
            prefill = true;
            "prefilled_message" = "This can be deleted";
        };
         */
        id tweet_options = params[@"tweet_options"];
        if ([tweet_options isKindOfClass:[NSDictionary class]]) {
            NSString *downloadLink = tweet_options[@"download_link"];
            self.downloadLink = (downloadLink.length > 0) ? downloadLink : nil;
            NSString *prefilledMessage = tweet_options[@"prefilled_message"];
            self.twitterPrefilledMessage = (prefilledMessage.length > 0) ? prefilledMessage : nil;
            NSString *forcedTag = tweet_options[@"forced_tag"];
            self.twitterForcedTag = (forcedTag.length > 0) ? forcedTag : nil;
        }
        NSString *mediaLength = params[@"twitter_media_characters"];
        if ([mediaLength isKindOfClass:[NSString class]]) {
            self.twitterMediaLength = mediaLength.length > 0 ? mediaLength.integerValue : 25;
        } else {
            self.twitterMediaLength = 25;
        }
        
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