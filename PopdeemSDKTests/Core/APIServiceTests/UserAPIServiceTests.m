//
//  UserAPIServiceTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 19/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import "Nocilla.h"
#import "PDUserAPIService.h"
#import "PDConstants.h"
#import "PopdeemSDK.h"

@interface UserAPIServiceTests : XCTestCase

@end

@implementation UserAPIServiceTests

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

#pragma mark - Get User Details -
/*
 Test the error handling of the getUserDetails API Service method
 */
- (void) testGetUserDetails_500Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async 500 Error"];
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/1231",API_URL,USERS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(500)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service getUserDetailsForId:@"1231" authenticationToken:@"token" completion:^(PDUser* user, NSError *error) {
    expect(error).toNot.beNil;
    if (error) {
      //Check the error for the code
      expect(error.code).to.equal(500);
      [expectation fulfill];
    }
    [self afterEach];
  }];
  //Wait 1 second for fulfill method called, otherwise fail:
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    if(error)
    {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
    [self afterEach];
  }];
}

- (void) testGetUserDetails_504Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async 500 Error"];
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/1231",API_URL,USERS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(504)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service getUserDetailsForId:@"1231" authenticationToken:@"token" completion:^(PDUser* user, NSError *error) {
    expect(error).toNot.beNil;
    if (error) {
      //Check the error for the code
      expect(error.code).to.equal(504);
      [expectation fulfill];
    }
    [self afterEach];
  }];
  //Wait 1 second for fulfill method called, otherwise fail:
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    if(error)
    {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
    [self afterEach];
  }];
}

/*
 Test the mechanics of the Get User Details API Service
 Should result in a user being created from the JSON in the response body
 */
- (void) testGetUserDetails_200OK {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async 200 OK"];
  NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"User" ofType:@"json"];
  NSString *userJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
  
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/1231",API_URL,USERS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(200)
  .withBody(userJSON)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service getUserDetailsForId:@"1231" authenticationToken:@"token" completion:^(PDUser* user, NSError *error) {
    expect(error).to.beNil;
    expect(user).toNot.beNil;
    expect(user.identifier).to.equal(1231);
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

#pragma mark - Register User -
/*
 Test the error handling of the registerUser API Service method
 */
- (void) testRegisterUser_500Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async 500 Error"];
  NSString *requestString = [NSString stringWithFormat:@"%@/%@",API_URL,USERS_PATH];
  stubRequest(@"POST", requestString)
  .andReturn(500)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service registerUserwithFacebookAccesstoken:@"Token" facebookId:@"ID" completion:^(PDUser *user, NSError *error){
    expect(error).toNot.beNil;
    expect(error.code).to.equal(500);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    if(error)
    {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
    [self afterEach];
  }];
}

- (void) testRegisterUser_504Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async 504 Error"];
  NSString *requestString = [NSString stringWithFormat:@"%@/%@",API_URL,USERS_PATH];
  stubRequest(@"POST", requestString)
  .andReturn(504)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service registerUserwithFacebookAccesstoken:@"Token" facebookId:@"ID" completion:^(PDUser *user, NSError *error){
    expect(error).toNot.beNil;
    expect(error.code).to.equal(504);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    if(error)
    {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
    [self afterEach];
  }];
}

/*
 Test the mechanics of the Regiser User API Service
 Should result in a user being created from the JSON in the response body
 */
- (void) testRegisterUser_200OK {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async 200 OK"];
  NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"User" ofType:@"json"];
  NSString *userJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
  
  NSString *requestString = [NSString stringWithFormat:@"%@/%@",API_URL,USERS_PATH];
  stubRequest(@"POST", requestString)
  .andReturn(200)
  .withBody(userJSON)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service registerUserwithFacebookAccesstoken:@"" facebookId:@"" completion:^(PDUser* user, NSError *error) {
    expect(error).to.beNil;
    expect(user).toNot.beNil;
    expect(user.identifier).to.equal(1231);
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

#pragma mark - Update User -

- (void) testUpdateUser_500Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async 500 Error"];
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/1231",API_URL,USERS_PATH];
  stubRequest(@"PUT", requestString)
  .andReturn(500)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service updateUserWithCompletion:^(PDUser *user, NSError *error){
    expect(error).toNot.beNil;
    expect(error.code).to.equal(500);
    [expectation fulfill];
    [self afterEach];
  }];
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error){
    if(error)
    {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
    [self afterEach];
  }];
}

- (void) testUpdateUser_504Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async 504 Error"];
  
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/1231",API_URL,USERS_PATH];
  stubRequest(@"PUT", requestString)
  .andReturn(504)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service updateUserWithCompletion:^(PDUser *user, NSError *error){
    expect(error).toNot.beNil;
    expect(error.code).to.equal(504);
    [expectation fulfill];
    [self afterEach];
  }];
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error){
    if(error)
    {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
    [self afterEach];
  }];
}

- (void) testUpdateUser_200OK {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Test Async 200 OK"];
  NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"User" ofType:@"json"];
  NSString *userJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
  
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/1231",API_URL,USERS_PATH];
  stubRequest(@"PUT", requestString)
  .andReturn(200)
  .withBody(userJSON)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service updateUserWithCompletion:^(PDUser *user, NSError *error) {
    expect(error).to.beNil;
    expect(user).toNot.beNil;
    expect(user.identifier).to.equal(1231);
    [expectation fulfill];
    [self afterEach];
  }];
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error){
    if(error)
    {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
    [self afterEach];
  }];
}

@end
