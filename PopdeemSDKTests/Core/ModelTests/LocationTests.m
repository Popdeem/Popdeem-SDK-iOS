//
//  LocationTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import "PDLocation.h"

@interface LocationTests : XCTestCase {
    PDLocation *location;
}

@end

@implementation LocationTests

- (void)setUp {
    [super setUp];
    
    NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Location" ofType:@"json"];
    NSString *userJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [userJSON dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [[NSError alloc] init];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];

    location = [[PDLocation alloc] initFromApi:json];
}

- (void)tearDown {
    [super tearDown];
}

- (void) testIdentifier {
    expect(location.id).to.equal(159);
}

- (void) testLocation {
    expect(location.geoLocation.latitude).to.beCloseToWithin(53.3735, 0.01);
    expect(location.geoLocation.longitude).to.beCloseToWithin(-6.17981, 0.01);
}

- (void) testTwitterPageId {
    expect(location.twitterPageId).to.beNil;
}

- (void) testFacebookPageId {
    expect(location.fbPageId).to.beNil;
}

- (void) testNumberOfRewards {
    expect(location.numberOfRewards).to.equal(0);
}

- (void) testBrandName {
//    expect(location.brand.name).to.equal(@"NO user brand");
}

- (void) testBrandId {
//    expect(location.brand.id).to.equal(102);
}
@end
