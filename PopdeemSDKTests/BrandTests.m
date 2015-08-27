//
//  BrandTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

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
    NSError *err = [[NSError alloc] init];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    
    brand = [[PDBrand alloc] initFromApi:json];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testIdentifier {
    assertThatInteger(brand.identifier, equalToInteger(123));
}

- (void) testBrandName {
    assertThat(brand.name, equalTo(@"Conors Coffee"));
}

- (void) testLogoUrlString {
    assertThat(brand.logoUrlString, equalTo(@"http://s3-eu-west-1.amazonaws.com/popdeem-staging/brands/logo_images/000/000/123/original/Untitled_5.png?1440414100"));
}

- (void) testCoverUrlString {
    assertThat(brand.coverUrlString, equalTo(@"http://s3-eu-west-1.amazonaws.com/popdeem-staging/brands/cover_images/000/000/123/original/coffeeheader.png?1440414101"));
}

- (void) testContacts {
    assertThat(brand.phoneNumber, equalTo(@"018251508"));
    assertThat(brand.email, equalTo(@"info@conorscoffee.ie"));
    assertThat(brand.web, equalTo(@"www.conorscoffee.ie"));
    assertThat(brand.facebook, equalTo(@"facebook.com/ccoffee"));
    assertThat(brand.twitter, equalTo(@"@ccoffee"));
}

-(void) testOpeningHours {
    assertThatBool(brand.openingHours.monday.isClosedForDay, isFalse());
    assertThat(brand.openingHours.monday.openingHour, equalTo(@9));
    assertThat(brand.openingHours.monday.openingMinute, equalTo(@0));
    assertThat(brand.openingHours.monday.closingHour, equalTo(@17));
    assertThat(brand.openingHours.monday.closingMinute, equalTo(@0));
    
    assertThatBool(brand.openingHours.tuesday.isClosedForDay, isFalse());
    assertThat(brand.openingHours.tuesday.openingHour, equalTo(@9));
    assertThat(brand.openingHours.tuesday.openingMinute, equalTo(@0));
//    assertThat(brand.openingHours.tuesday.closingHour, equalTo(@17));
    assertThat(brand.openingHours.tuesday.closingMinute, equalTo(@0));
    
    assertThatBool(brand.openingHours.wednesday.isClosedForDay, isFalse());
    assertThat(brand.openingHours.wednesday.openingHour, equalTo(@9));
    assertThat(brand.openingHours.wednesday.openingMinute, equalTo(@0));
    assertThat(brand.openingHours.wednesday.closingHour, equalTo(@17));
    assertThat(brand.openingHours.wednesday.closingMinute, equalTo(@0));
    
    assertThatBool(brand.openingHours.thursday.isClosedForDay, isFalse());
    assertThat(brand.openingHours.thursday.openingHour, equalTo(@9));
    assertThat(brand.openingHours.thursday.openingMinute, equalTo(@0));
    assertThat(brand.openingHours.thursday.closingHour, equalTo(@17));
    assertThat(brand.openingHours.thursday.closingMinute, equalTo(@0));
    
    assertThatBool(brand.openingHours.friday.isClosedForDay, isFalse());
    assertThat(brand.openingHours.friday.openingHour, equalTo(@9));
    assertThat(brand.openingHours.friday.openingMinute, equalTo(@0));
    assertThat(brand.openingHours.friday.closingHour, equalTo(@17));
    assertThat(brand.openingHours.friday.closingMinute, equalTo(@0));
    
    assertThatBool(brand.openingHours.saturday.isClosedForDay, isFalse());
    assertThat(brand.openingHours.saturday.openingHour, equalTo(@9));
    assertThat(brand.openingHours.saturday.openingMinute, equalTo(@0));
    assertThat(brand.openingHours.saturday.closingHour, equalTo(@17));
    assertThat(brand.openingHours.saturday.closingMinute, equalTo(@0));
    
    assertThatBool(brand.openingHours.sunday.isClosedForDay, isFalse());
    assertThat(brand.openingHours.sunday.openingHour, equalTo(@9));
    assertThat(brand.openingHours.sunday.openingMinute, equalTo(@0));
    assertThat(brand.openingHours.sunday.closingHour, equalTo(@17));
    assertThat(brand.openingHours.sunday.closingMinute, equalTo(@0));
}

@end
