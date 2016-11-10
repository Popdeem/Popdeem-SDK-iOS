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

#pragma mark - Test Twitter Connect -

- (void) testConnectTwitterAccount_500Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"test Twitter 500 Error"];
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/connect_social_account",API_URL,USERS_PATH];
  stubRequest(@"POST", requestString)
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
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/connect_social_account",API_URL,USERS_PATH];
  stubRequest(@"POST", requestString)
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
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/connect_social_account",API_URL,USERS_PATH];
  stubRequest(@"POST", requestString)
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
