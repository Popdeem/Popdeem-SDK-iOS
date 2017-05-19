//
//  RewardTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
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
    NSError *err = [[NSError alloc] initWithDomain:NSURLErrorDomain code:27501 userInfo:nil];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    
    reward = [[PDReward alloc] initFromApi:json];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testRewardExists {
    expect(reward).toNot.beNil;
}

- (void) testIdentifier {
    expect(reward.identifier).to.equal(728);
}

- (void) testRewardType {
    expect(reward.type).to.equal(PDRewardTypeCoupon);
}

- (void) testSocialMediaType {
    for (NSNumber *n in reward.socialMediaTypes) {
        if ([n isEqual:@(PDSocialMediaTypeFacebook)]) {
//            assert(YES);
        }
    }
}

- (void) testCoverImageUrl {
    expect(reward.coverImageUrl).to.equal(@"http://s3-eu-west-1.amazonaws.com/popdeem/rewards/cover_images/000/000/728/original/10401200_47976816068_100_n.jpg?1440068738");
}

- (void) testRewardDescription {
    expect(reward.rewardDescription).to.equal(@"Test Reward");
}

- (void) testRewardRules {
    expect(reward.rewardRules).to.equal(@"Test Rules");
}

- (void) testCreatedAt {
    expect(reward.createdAt).to.equal(1440068740);
}

- (void) testAction {
    expect(reward.action).to.equal(PDRewardActionPhoto);
}

- (void) testStatus {
    expect(reward.status).to.equal(PDRewardStatusLive);
}

- (void) testRemainingCount {
    expect(reward.remainingCount).to.equal(100);
}

- (void) testAvailability {
    
}

- (void) testLocations {

}

@end
