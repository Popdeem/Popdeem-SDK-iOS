//
//  BrandAPIServiceTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import "Nocilla.h"
#import "PDBrandAPIService.h"
#import "PDBrand.h"
#import "PDBrandStore.h"
#import "PDConstants.h"
#import "PopdeemSDK.h"

@interface BrandAPIServiceTests : XCTestCase

@end

@implementation BrandAPIServiceTests

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

- (void) testGetBrands_500Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Test 500 error on get Brands"];
  NSString *requestString = [NSString stringWithFormat:@"%@/%@",API_URL,BRANDS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(500)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDBrandApiService *service = [[PDBrandApiService alloc] init];
  [service getBrandsWithCompletion:^(NSError *error){
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

- (void) testGetBrands_504Error {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Test 504 error on get Brands"];
  
  NSString *requestString = [NSString stringWithFormat:@"%@/%@",API_URL,BRANDS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(504)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDBrandApiService *service = [[PDBrandApiService alloc] init];
  [service getBrandsWithCompletion:^(NSError *error){
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

- (void) testGetBrands_200OK {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Test 200OK on get Brands"];
  NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Brands" ofType:@"json"];
  NSString *brandsJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
  
  NSString *requestString = [NSString stringWithFormat:@"%@/%@",API_URL,BRANDS_PATH];
  stubRequest(@"GET", requestString)
  .andReturn(200)
  .withBody(brandsJSON)
  .withHeaders(@{@"Content-Type": @"application/json"});
  
  PDBrandApiService *service = [[PDBrandApiService alloc] init];
  [service getBrandsWithCompletion:^(NSError *error){
    expect(error).to.beNil;
    PDBrand *b = [PDBrandStore findBrandByIdentifier:123];
    expect(b).toNot.beNil;
    expect(b.identifier).to.equal(123);
    [expectation fulfill];
    [self afterEach];
  }];
  [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    [self afterEach];
    if (error) XCTFail(@"Expectation Failed with error: %@", error);
  }];
}
@end
