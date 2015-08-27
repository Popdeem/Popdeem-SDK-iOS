//
//  PDReward.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDReward.h"
#import "PDUser.h"

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
        
        NSString *action = params[@"action"];
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
        
        return self;
    }
    return nil;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    return nil;
}

@end
