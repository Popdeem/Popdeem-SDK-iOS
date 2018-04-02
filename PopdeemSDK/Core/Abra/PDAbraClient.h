//
//  PDAbraClient.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/09/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AbraLogEvent(name, properties) \
logEvent((name),(properties))

#define AbraOnboardUser() \
[[PDAbraClient sharedInstance] onboardUser]

#define AbraKeyForRewardType(rewardType) \
keyForRewardType((rewardType))

#define AbraKeyForRewardAction(rewardAction) \
keyForRewardAction((rewardAction))

@interface PDAbraClient : NSObject

+ (instancetype) sharedInstance;
@property (nonatomic, strong) NSString *projectToken;

- (void) onboardUser;
extern void logEvent(NSString *eventName, NSDictionary *properties);
extern NSString* keyForRewardType(NSInteger rewardType);
extern NSString* keyForRewardAction(NSInteger rewardAction);
@end
