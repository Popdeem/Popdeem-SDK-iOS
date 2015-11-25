//
//  APIServiceTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import "PDAPIService.h"
#import "PDConstants.h"

@interface APIServiceTests : XCTestCase

@end

@implementation APIServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAPIURL {
    PDAPIService *apiservice = [[PDAPIService alloc] init];
    expect(apiservice.baseUrl).to.equal(API_URL);
}

@end
