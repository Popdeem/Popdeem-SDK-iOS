//
//  FeedAPIServiceTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import "Nocilla.h"
#import "PDFeedAPIService.h"
#import "PDFeedItem.h"
#import "PDConstants.h"
#import "PopdeemSDK.h"
#import "PDFeeds.h"

@interface FeedAPIServiceTests : XCTestCase

@end

@implementation FeedAPIServiceTests

- (void)setUp {
    [super setUp];
  [PopdeemSDK testingWithAPIKey:@"8abcb2bd-edf2-4007-bb40-97e43b8a9498"];
    [[LSNocilla sharedInstance] start];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void) afterEach {
    [[LSNocilla sharedInstance] clearStubs];
	stubRequest(@"POST", @"http://insights.popdeem.com/v1/event").
	withHeaders(@{ @"Accept": @"application/json", @"Api-Key": @"8abcb2bd-edf2-4007-bb40-97e43b8a9498", @"Content-Length": @"173", @"Content-Type": @"application/json", @"Device-Id": @"E1183E0C-3D46-4153-BE43-21564C706053", @"User-Id": @"1231" }).
	withBody(@"{\"event\":{\"tag\":\"onboard\",\"properties\":{}},\"traits\":{\"id\":\"1231\",\"gender\":\"Male\",\"first_name\":\"John\",\"push_notifications_enabled\":\"No\",\"last_name\":\"Doe\",\"ip\":\"192.168.1.4\"}}");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [[LSNocilla sharedInstance] clearStubs];
    [[LSNocilla sharedInstance] stop];
}

#pragma mark - Get Feeds -

- (NSString*)apiUrl {
    return [NSString stringWithFormat:@"%@/%@",[[PopdeemSDK sharedInstance] apiURL],FEEDS_PATH];
}

- (void) testGetFeeds_500Error {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test get Feeds 500 Error"];
    
    stubRequest(@"GET", [self apiUrl])
    .andReturn(500)
    .withHeaders(@{@"Content-Type" : @"application/json"});
    
    PDFeedAPIService *service = [[PDFeedAPIService alloc] init];
    [service getFeedsLimit:10 completion:^(NSError *error){
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

- (void) testGetFeeds_504Error {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test get Feeds 504 Error"];
    
    stubRequest(@"GET", [self apiUrl])
    .andReturn(504)
    .withHeaders(@{@"Content-Type" : @"application/json"});
    
    PDFeedAPIService *service = [[PDFeedAPIService alloc] init];
    [service getFeedsLimit:10 completion:^(NSError *error){
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

- (void) testGetFeeds_200OK {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test Feeds 200 OK"];

    NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Feeds" ofType:@"json"];
    NSString *feedsJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];

    stubRequest(@"GET", [self apiUrl])
    .andReturn(200)
    .withBody(feedsJSON)
    .withHeaders(@{@"Content-Type" : @"application/json"});

    PDFeedAPIService *service = [[PDFeedAPIService alloc] init];
    [service getFeedsLimit:1 completion:^(NSError* error){
        expect(error).to.beNil;
        NSMutableArray *feed = [PDFeeds feed];
        expect(feed.count).to.equal(1);
        [self afterEach];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        [self afterEach];
        if (error) XCTFail(@"Expectation Failed with error: %@", error);
    }];
}


@end
