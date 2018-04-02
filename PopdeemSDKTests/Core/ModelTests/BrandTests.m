//
//  BrandTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import "PDBrand.h"

@interface BrandTests : XCTestCase {
    PDBrand *brand;
}

@end

@implementation BrandTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Brand" ofType:@"json"];
    NSString *userJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [userJSON dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [[NSError alloc] initWithDomain:NSURLErrorDomain code:27501 userInfo:nil];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    
    brand = [[PDBrand alloc] initFromApi:json];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testExists {
    expect(brand).toNot.beNil;
}

- (void) testIdentifier {
    expect(brand.identifier).to.equal(123);
}

- (void) testBrandName {
    expect(brand.name).to.equal(@"Conors Coffee");
}

- (void) testLogoUrlString {
    expect(brand.logoUrlString).to.equal(@"http://s3-eu-west-1.amazonaws.com/popdeem-staging/brands/logo_images/000/000/123/original/Untitled_5.png?1440414100");
}

- (void) testCoverUrlString {
    expect(brand.coverUrlString).to.equal(@"http://s3-eu-west-1.amazonaws.com/popdeem-staging/brands/cover_images/000/000/123/original/coffeeheader.png?1440414101");
}

- (void) testContacts {
    expect(brand.phoneNumber).to.equal(@"018251508");
    expect(brand.email).to.equal(@"info@conorscoffee.ie");
    expect(brand.web).to.equal(@"www.conorscoffee.ie");
    expect(brand.facebook).to.equal(@"facebook.com/ccoffee");
    expect(brand.twitter).to.equal(@"@ccoffee");
}

-(void) testOpeningHours {
    expect(brand.openingHours.monday.isClosedForDay).to.equal(NO);
    expect(brand.openingHours.monday.openingHour).to.equal(@9);
    expect(brand.openingHours.monday.openingMinute).to.equal(@0);
    expect(brand.openingHours.monday.closingHour).to.equal(@17);
    expect(brand.openingHours.monday.closingMinute).to.equal(@0);

    expect(brand.openingHours.tuesday.isClosedForDay).to.equal(NO);
    expect(brand.openingHours.tuesday.openingHour).to.equal(@9);
    expect(brand.openingHours.tuesday.openingMinute).to.equal(@0);
    expect(brand.openingHours.tuesday.closingHour).to.equal(@0);
    expect(brand.openingHours.tuesday.closingMinute).to.equal(@0);
    
    expect(brand.openingHours.wednesday.isClosedForDay).to.equal(NO);
    expect(brand.openingHours.wednesday.openingHour).to.equal(@9);
    expect(brand.openingHours.wednesday.openingMinute).to.equal(@0);
    expect(brand.openingHours.wednesday.closingHour).to.equal(@17);
    expect(brand.openingHours.wednesday.closingMinute).to.equal(@0);
    
    expect(brand.openingHours.thursday.isClosedForDay).to.equal(NO);
    expect(brand.openingHours.thursday.openingHour).to.equal(@9);
    expect(brand.openingHours.thursday.openingMinute).to.equal(@0);
    expect(brand.openingHours.thursday.closingHour).to.equal(@17);
    expect(brand.openingHours.thursday.closingMinute).to.equal(@0);
    
    expect(brand.openingHours.friday.isClosedForDay).to.equal(NO);
    expect(brand.openingHours.friday.openingHour).to.equal(@9);
    expect(brand.openingHours.friday.openingMinute).to.equal(@0);
    expect(brand.openingHours.friday.closingHour).to.equal(@17);
    expect(brand.openingHours.friday.closingMinute).to.equal(@0);
    
    expect(brand.openingHours.saturday.isClosedForDay).to.equal(NO);
    expect(brand.openingHours.saturday.openingHour).to.equal(@9);
    expect(brand.openingHours.saturday.openingMinute).to.equal(@0);
    expect(brand.openingHours.saturday.closingHour).to.equal(@17);
    expect(brand.openingHours.saturday.closingMinute).to.equal(@0);
    
    expect(brand.openingHours.sunday.isClosedForDay).to.equal(NO);
    expect(brand.openingHours.sunday.openingHour).to.equal(@9);
    expect(brand.openingHours.sunday.openingMinute).to.equal(@0);
    expect(brand.openingHours.sunday.closingHour).to.equal(@17);
    expect(brand.openingHours.sunday.closingMinute).to.equal(@0);
}

@end
