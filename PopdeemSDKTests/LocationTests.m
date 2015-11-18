//
//  LocationTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "PDLocation.h"

@interface LocationTests : XCTestCase {
    PDLocation *location;
}

@end

@implementation LocationTests

//- (void)setUp {
//    [super setUp];
//    
//    NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Location" ofType:@"json"];
//    NSString *userJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
//    NSData *data = [userJSON dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err = [[NSError alloc] init];
//    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
//    
//    location = [[PDLocation alloc] initFromApi:json];
//}
//
//- (void)tearDown {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}
//
//- (void) testIdentifier {
////    assertThatInteger(location.identifier, equalToInteger(159));
//}
//
//- (void) testLocation {
////    assertThatFloat(location.geoLocation.latitude, equalToFloat(53.3735));
////    assertThatFloat(location.geoLocation.longitude, equalToFloat(-6.17981));
//}
//
//- (void) testTwitterPageId {
////    assertThat(location.twitterPageId, equalTo(nil));
//}
//
//- (void) testFacebookPageId {
////    assertThat(location.facebookPageId, equalTo(nil));
//}
//
//- (void) testNumberOfRewards {
////    assertThatInteger(location.numberOfRewards, equalToInteger(0));
//}
//
//- (void) testBrandName {
////    assertThat(location.brandName, equalTo(@"NO user brand"));
//}
//
//- (void) testBrandId {
////    assertThatInteger(location.brandIdentifier, equalToInteger(102));
//}
@end
