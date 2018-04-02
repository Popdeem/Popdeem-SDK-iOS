//
//  WalletAPIServiceTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import "Nocilla.h"
#import "PDWalletAPIService.h"
#import "PDReward.h"
#import "PDWallet.h"
#import "PDConstants.h"
#import "PopdeemSDK.h"
#import "PDConstants.h"

@interface WalletAPIServiceTests : XCTestCase

@end

@implementation WalletAPIServiceTests

- (void)setUp {
    [super setUp];
    [PopdeemSDK testingWithAPIKey:@"8abcb2bd-edf2-4007-bb40-97e43b8a9498"];
    [[LSNocilla sharedInstance] start];
	stubRequest(@"POST", @"http://insights.popdeem.com/v1/event").
	withHeaders(@{ @"Accept": @"application/json", @"Api-Key": @"8abcb2bd-edf2-4007-bb40-97e43b8a9498", @"Content-Length": @"173", @"Content-Type": @"application/json", @"Device-Id": @"E1183E0C-3D46-4153-BE43-21564C706053", @"User-Id": @"1231" }).
	withBody(@"{\"event\":{\"tag\":\"onboard\",\"properties\":{}},\"traits\":{\"id\":\"1231\",\"gender\":\"Male\",\"first_name\":\"John\",\"push_notifications_enabled\":\"No\",\"last_name\":\"Doe\",\"ip\":\"192.168.1.4\"}}");
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void) afterEach {
    [[LSNocilla sharedInstance] clearStubs];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [[LSNocilla sharedInstance] clearStubs];
    [[LSNocilla sharedInstance] stop];
}

#pragma mark - Get all rewards in Wallet -

- (void) testGetAllRewardsInWallet_500Error {
    XCTestExpectation *expectation = [self expectationWithDescription:@"test get all rewards 500 Error"];
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/wallet",[[PopdeemSDK sharedInstance] apiURL],REWARDS_PATH];
    stubRequest(@"GET", requestString)
    .andReturn(500)
    .withHeaders(@{@"Content-Type": @"application/json"});
    
    PDWalletAPIService *service = [[PDWalletAPIService alloc] init];
    [service getRewardsInWalletWithCompletion:^(NSError *error){
        expect(error).toNot.beNil;
        expect(error.code).to.equal(500);
        [self afterEach];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        [self afterEach];
        if (error) XCTFail(@"Expectation Failed with error: %@", error);
    }];
}

- (void) testGetAllRewardsInWallet_504Error {
    XCTestExpectation *expectation = [self expectationWithDescription:@"test get all rewards 504 Error"];
    NSString *requestString = [NSString stringWithFormat:@"%@/%@/wallet",[[PopdeemSDK sharedInstance] apiURL],REWARDS_PATH];
    stubRequest(@"GET", requestString)
    .andReturn(504)
    .withHeaders(@{@"Content-Type": @"application/json"});
    
    PDWalletAPIService *service = [[PDWalletAPIService alloc] init];
    [service getRewardsInWalletWithCompletion:^(NSError *error){
        expect(error).toNot.beNil;
        expect(error.code).to.equal(504);
        [self afterEach];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        [self afterEach];
        if (error) XCTFail(@"Expectation Failed with error: %@", error);
    }];
}

- (void) testGetAllRewardsInWallet_200OK {
    XCTestExpectation *expectation = [self expectationWithDescription:@"test get all rewards 504 Error"];
    NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Rewards" ofType:@"json"];
    NSString *rewardsJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
    NSString *requestString = [NSString stringWithFormat:@"%@/%@/wallet",[[PopdeemSDK sharedInstance] apiURL],REWARDS_PATH];
    stubRequest(@"GET", requestString)
    .andReturn(200)
    .withBody(rewardsJSON)
    .withHeaders(@{@"Content-Type": @"application/json"});
    
    PDWalletAPIService *service = [[PDWalletAPIService alloc] init];
    [service getRewardsInWalletWithCompletion:^(NSError *error){
        expect(error).to.beNil;
        PDReward *r = [PDWallet find:728];
        expect(r).toNot.beNil;
        expect(r.identifier).to.equal(728);
        [self afterEach];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        [self afterEach];
        if (error) XCTFail(@"Expectation Failed with error: %@", error);
    }];
}

@end
