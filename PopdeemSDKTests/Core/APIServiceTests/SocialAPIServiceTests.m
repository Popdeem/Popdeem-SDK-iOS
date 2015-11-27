//
//  SocialAPIServiceTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import "Nocilla.h"
#import "PDSocialAPIService.h"
#import "PDConstants.h"
#import "PopdeemSDK.h"

@interface SocialAPIServiceTests : XCTestCase

@end

@implementation SocialAPIServiceTests

- (void)setUp {
    [super setUp];
    [PopdeemSDK withAPIKey:@"8abcb2bd-edf2-4007-bb40-97e43b8a9498"];
    [[LSNocilla sharedInstance] start];
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

#pragma mark - Test Twitter Connect -

- (void) testConnectTwitterAccount_500Error {
    XCTestExpectation *expectation = [self expectationWithDescription:@"test Twitter 500 Error"];
    stubRequest(@"POST", @"http://staging.popdeem.com/api/v2/users/connect_social_account")
    .andReturn(500)
    .withHeaders(@{@"Content-Type": @"application/json"});
    
    PDSocialAPIService *service = [[PDSocialAPIService alloc] init];
    [service connectTwitterAccount:@"" accessToken:@"" accessSecret:@"" completion:^(NSError* error){
        expect(error).toNot.beNil;
        expect(error.code).to.equal(500);
        [expectation fulfill];
        [self afterEach];
    }];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        [self afterEach];
    }];
}

- (void) testConnectTwitterAccount_504Error {
    XCTestExpectation *expectation = [self expectationWithDescription:@"test Twitter 500 Error"];
    stubRequest(@"POST", @"http://staging.popdeem.com/api/v2/users/connect_social_account")
    .andReturn(504)
    .withHeaders(@{@"Content-Type": @"application/json"});
    
    PDSocialAPIService *service = [[PDSocialAPIService alloc] init];
    [service connectTwitterAccount:@"" accessToken:@"" accessSecret:@"" completion:^(NSError* error){
        expect(error).toNot.beNil;
        expect(error.code).to.equal(504);
        [expectation fulfill];
        [self afterEach];
    }];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        [self afterEach];
    }];
}

- (void) testConnectTwitterAccount_200OK {
    XCTestExpectation *expectation = [self expectationWithDescription:@"test Twitter 500 Error"];
    stubRequest(@"POST", @"http://staging.popdeem.com/api/v2/users/connect_social_account")
    .andReturn(200)
    .withHeaders(@{@"Content-Type": @"application/json"});
    
    PDSocialAPIService *service = [[PDSocialAPIService alloc] init];
    [service connectTwitterAccount:@"" accessToken:@"" accessSecret:@"" completion:^(NSError* error){
        expect(error).to.beNil;
        [expectation fulfill];
        [self afterEach];
    }];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        [self afterEach];
    }];
}

@end
