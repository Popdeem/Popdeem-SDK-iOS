//
//  LocationAPIServiceTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import "Nocilla.h"
#import "PDLocationAPIService.h"
#import "PDLocation.h"
#import "PDLocationStore.h"
#import "PDConstants.h"
#import "PopdeemSDK.h"

@interface LocationAPIServiceTests : XCTestCase

@end

@implementation LocationAPIServiceTests

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

#pragma mark - Get All Locations -

- (void) testGetAllLocations_500Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Test 500 Error get All Locations"];
  NSString *requestString = [NSString stringWithFormat:@"%@/%@",API_URL,LOCATIONS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(500)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDLocationAPIService *service = [[PDLocationAPIService alloc] init];
  [service getAllLocationsWithCompletion:^(NSError *error){
    expect(error).toNot.beNil;
    expect(error.code).to.equal(500);
    [expectation fulfill];
    [self afterEach];
  }];
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    [self afterEach];
    if (error) XCTFail(@"Expectation Failed with error: %@", error);
  }];
}

- (void) testGetAllLocations_504Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Test 504 Error get All Locations"];
  
  NSString *requestString = [NSString stringWithFormat:@"%@/%@",API_URL,LOCATIONS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(504)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDLocationAPIService *service = [[PDLocationAPIService alloc] init];
  [service getAllLocationsWithCompletion:^(NSError *error){
    expect(error).toNot.beNil;
    expect(error.code).to.equal(504);
    [expectation fulfill];
    [self afterEach];
  }];
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    [self afterEach];
    if (error) XCTFail(@"Expectation Failed with error: %@", error);
  }];
}

- (void) testGetAllLocations_200OK {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Test 200 OK get All Locations"];
  NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Location" ofType:@"json"];
  NSString *locationJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
  
  NSMutableString *locationArr = [NSMutableString stringWithFormat:@"{\"locations\" : [%@]}", locationJSON];
  
  NSString *requestString = [NSString stringWithFormat:@"%@/%@",API_URL,LOCATIONS_PATH];
  stubRequest(@"GET", requestString)    .andReturn(200)
  .withBody(locationArr)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDLocationAPIService *service = [[PDLocationAPIService alloc] init];
  [service getAllLocationsWithCompletion:^(NSError *error){
    expect(error).to.beNil;
    [expectation fulfill];
    PDLocation *loc = [PDLocationStore find:159];
    expect(loc).toNot.beNil;
    expect(loc.identifier).to.equal(159);
    [self afterEach];
  }];
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    [self afterEach];
    if (error) XCTFail(@"Expectation Failed with error: %@", error);
  }];
}

#pragma mark - Get Location for ID -

- (void) testGetLocationForID_500Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Test 500 Error get Location"];
  
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/1",API_URL,LOCATIONS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(500)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDLocationAPIService *service = [[PDLocationAPIService alloc] init];
  [service getLocationForId:1 completion:^(NSError *error){
    expect(error).toNot.beNil;
    expect(error.code).to.equal(500);
    [expectation fulfill];
    [self afterEach];
  }];
  
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    [self afterEach];
    if (error) XCTFail(@"Expectation Failed with error: %@", error);
  }];
}

- (void) testGetLocationForID_504Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Test 504 Error get Location"];
  
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/1",API_URL,LOCATIONS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(504)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDLocationAPIService *service = [[PDLocationAPIService alloc] init];
  [service getLocationForId:1 completion:^(NSError *error){
    expect(error).toNot.beNil;
    expect(error.code).to.equal(504);
    [expectation fulfill];
    [self afterEach];
  }];
  
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    [self afterEach];
    if (error) XCTFail(@"Expectation Failed with error: %@", error);
  }];
}

- (void) testGetLocationForID_200OK {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Test 200 OK get Location"];
  NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Location" ofType:@"json"];
  NSString *locationJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
  
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/1",API_URL,LOCATIONS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(200)
  .withBody(locationJSON)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDLocationAPIService *service = [[PDLocationAPIService alloc] init];
  [service getLocationForId:1 completion:^(NSError *error){
    expect(error).to.beNil;
    PDLocation *loc = [PDLocationStore find:159];
    expect(loc).toNot.beNil;
    expect(loc.identifier).to.equal(159);
    [expectation fulfill];
    [self afterEach];
  }];
  
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    [self afterEach];
    if (error) XCTFail(@"Expectation Failed with error: %@", error);
  }];
}

#pragma mark - Get Locations for Brand Id -

- (void) testGetLocationsForBrandId_500Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Test Get Locations for Brand ID 500 Error"];
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/1/locations",API_URL,BRANDS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(500)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDLocationAPIService *service = [[PDLocationAPIService alloc] init];
  [service getLocationsForBrandId:1 completion:^(NSError *error){
    expect(error).toNot.beNil;
    expect(error.code).to.equal(500);
    [expectation fulfill];
    [self afterEach];
  }];
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    [self afterEach];
    if (error) XCTFail(@"Expectation Failed with error: %@", error);
  }];
}

- (void) testGetLocationsForBrandId_504Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Test Get Locations for Brand ID 504 Error"];
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/1/locations",API_URL,BRANDS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(504)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDLocationAPIService *service = [[PDLocationAPIService alloc] init];
  [service getLocationsForBrandId:1 completion:^(NSError *error){
    expect(error).toNot.beNil;
    expect(error.code).to.equal(504);
    [expectation fulfill];
    [self afterEach];
  }];
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    [self afterEach];
    if (error) XCTFail(@"Expectation Failed with error: %@", error);
  }];
}

- (void) testGetLocationsForBrandId_200OK {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Test Get Locations for Brand ID 200OK"];
  NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Location" ofType:@"json"];
  NSString *locationJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
  
  NSMutableString *locationArr = [NSMutableString stringWithFormat:@"{\"locations\" : [%@]}", locationJSON];
  
  NSString *requestString = [NSString stringWithFormat:@"%@/%@/1/locations",API_URL,BRANDS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(200)
  .withBody(locationArr)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDLocationAPIService *service = [[PDLocationAPIService alloc] init];
  [service getLocationsForBrandId:1 completion:^(NSError *error){
    expect(error).to.beNil;
    PDLocation *loc = [PDLocationStore find:159];
    expect(loc).toNot.beNil;
    expect(loc.identifier).to.equal(159);
    [expectation fulfill];
    [self afterEach];
  }];
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    [self afterEach];
    if (error) XCTFail(@"Expectation Failed with error: %@", error);
  }];
}
@end
