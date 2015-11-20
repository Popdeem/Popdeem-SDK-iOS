//
//  UserTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 19/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import "PDUser.h"


@interface UserTests : XCTestCase {
    PDUser *_u;
}

@end

@implementation UserTests

- (void)setUp {
    [super setUp];
    NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"User" ofType:@"json"];
    NSString *userJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [userJSON dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [[NSError alloc] init];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    _u = [PDUser initFromAPI:json[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testUserExists {
    expect(_u).toNot.beNil;
}

- (void)testNames {
    expect(_u.firstName).to.equal(@"John");
    expect(_u.lastName).to.equal(@"Doe");
}
@end
