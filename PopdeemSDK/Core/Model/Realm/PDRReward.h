//
//  PDRReward.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 16/01/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "PDReward.h"
#import "PDUser.h"
NS_ASSUME_NONNULL_BEGIN
RLM_ARRAY_TYPE(NSInteger)
@interface PDRReward : RLMObject

//In Realm
//@property (nonatomic) NSInteger identifier;
//@property (nonatomic, strong) NSMutableDictionary *rawSocialMediaTypes;
//
////Ignored by Realm
//@property (nonatomic) PDRewardType type;
//@property (nonatomic, strong) NSMutableArray *socialMediaTypes;
//
//@property (nonatomic, strong) NSString *coverImageUrl;
//
//@property (nonatomic, strong) NSString *rewardDescription;
//@property (nonatomic, strong) NSString *rewardRules;
//
//@property (nonatomic) long createdAt;
//@property (nonatomic) long availableUntil;
//@property (nonatomic) long claimedAt;
//@property (nonatomic) BOOL unlimitedAvailability;
//
//@property (nonatomic) PDRewardAction action;
//@property (nonatomic) PDRewardStatus status;
//
//@property (nonatomic) NSInteger remainingCount;
//
//@property (nonatomic, strong) PDRewardCustomAvailability *customAvailability;
//
//@property (nonatomic, strong) NSMutableArray *locationIds;
//@property (nonatomic) NSInteger brandId;
//
//@property (nonatomic, strong, nullable) NSString *twitterForcedTag;
//@property (nonatomic, strong, nullable) NSString *downloadLink;
//@property (nonatomic, strong, nullable) NSString *twitterPrefilledMessage;
//@property (nonatomic) NSInteger twitterMediaLength;
//@property (nonatomic, strong, nullable) NSString *instagramForcedTag;
//@property (nonatomic, strong, nullable) NSString *instagramPrefilledMessage;
//@property (nonatomic, strong, nullable) NSString *recurrence;
//
//@property (nonatomic, strong, nullable) NSString *forcedTag;
//
//@property (nonatomic) PDSocialMediaType claimedSocialNetwork;
//@property (nonatomic, retain) NSArray *claimingSocialNetworks;
//
//@property (nonatomic) BOOL instagramVerified;
//@property (nonatomic) BOOL autoDiscovered;
//@property (nonatomic) BOOL verifyLocation;
//@property (nonatomic) BOOL revoked;
//@property (nonatomic) CGFloat distanceFromUser;
//@property (nonatomic) NSInteger countdownTimerDuration;
//@property (nonatomic, strong, nullable) NSString *creditString;
//
//@property (nonatomic, strong) NSMutableArray *locations;
//
//- (id) initFromApi:(NSDictionary*)params;
//- (void) downloadCoverImageCompletion:(void (^)(BOOL success))completion;
//- (NSString*) localizedDistanceToUserString;
//- (NSComparisonResult)compareDate:(PDReward *)otherObject;
//- (NSArray*) socialMediaTypes;
@end
RLM_ARRAY_TYPE(PDRReward)

NS_ASSUME_NONNULL_END

