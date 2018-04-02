//
//  PDAbraClient.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/09/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDAbraClient.h"
#import "PDAbraAPIService.h"
#import "PDReward.h"

@implementation PDAbraClient

+ (instancetype) sharedInstance {
	static PDAbraClient *sharedClient;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedClient = [[PDAbraClient alloc] init];
		sharedClient.projectToken = @"b414ae329d7993e2bce41198b899f871";
	});
	return sharedClient;
}

- (void) onboardUser {
	PDAbraAPIService *service = [[PDAbraAPIService alloc] init];
	[service onboardUser];
}

void logEvent(NSString *eventName, NSDictionary *properties) {
	PDAbraAPIService *service = [[PDAbraAPIService alloc] init];
	if (!properties) {
		properties = @{};
	}
	[service logEvent:eventName properties:properties];
}

NSString* keyForRewardType(NSInteger rewardType) {
	switch (rewardType) {
		case 1:
			return ABRA_PROPERTYVALUE_REWARD_TYPE_COUPON;
			break;
		case 2:
			return ABRA_PROPERTYVALUE_REWARD_TYPE_SWEEPSTAKE;
			break;
		default:
			return ABRA_PROPERTYVALUE_REWARD_TYPE_COUPON;
			break;
	}
}

NSString* keyForRewardAction(NSInteger rewardAction) {
	switch (rewardAction) {
		case 1:
			return ABRA_PROPERTYVALUE_REWARD_ACTION_CHECKIN;
			break;
		case 2:
			return ABRA_PROPERTYVALUE_REWARD_ACTION_PHOTO;
			break;
		default:
			return ABRA_PROPERTYVALUE_REWARD_ACTION_CHECKIN;
			break;
	}
}

@end
