//
//  RewardTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "PDReward.h"
#import "PDUser.h"


@interface RewardTests : XCTestCase {
    PDReward *reward;
}

@end

@implementation RewardTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Reward" ofType:@"json"];
    NSString *userJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [userJSON dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [[NSError alloc] init];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    
    
    
    reward = [[PDReward alloc] initFromApi:json];
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testIdentifier {
    assertThatInteger(reward.identifier, equalToInteger(728));
}

- (void) testRewardType {
    assertThatInteger(reward.type, equalToInteger(PDRewardTypeCoupon));
}

- (void) testSocialMediaType {
    for (NSNumber *n in reward.socialMediaTypes) {
        if ([n isEqual:@(PDSocialMediaTypeFacebook)]) {
            assert(YES);
        }
    }
}

- (void) testCoverImageUrl {
    assertThat(reward.coverImageUrl, equalTo(@"http://s3-eu-west-1.amazonaws.com/popdeem/rewards/cover_images/000/000/728/original/10401200_47976816068_100_n.jpg?1440068738"));
}

- (void) testRewardDescription {
    assertThat(reward.rewardDescription, equalTo(@"Test Reward"));
}

- (void) testRewardRules {
    assertThat(reward.rewardRules, equalTo(@"Test Rules"));
}

- (void) testCreatedAt {
    assertThatLong(reward.createdAt, equalToLong(1440068740));
}

- (void) testAction {
    assertThatInteger(reward.action, equalToInteger(PDRewardActionPhoto));
}

- (void) testStatus {
    assertThatInteger(reward.status, equalToInteger(PDRewardStatusLive));
}

- (void) testRemainingCount {
    assertThatInteger(reward.remainingCount, equalToInteger(100));
}

- (void) testAvailability {
    
}

- (void) testLocations {

}

@end
