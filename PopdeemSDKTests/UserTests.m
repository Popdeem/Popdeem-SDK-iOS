//
//  UserTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 19/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "PDUser.h"
@interface UserTests : XCTestCase {
    PDUser *user;
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
    
    
    user = [PDUser initFromAPI:json[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testUserExists {
    assertThat(user, isNot(nilValue()));
}

- (void) testFirstName {
    assertThat(user.firstName, equalTo(@"John"));
}

- (void) testLastName {
    assertThat(user.lastName, equalTo(@"Doe"));
}

- (void) testSex {
    assertThatInteger(user.gender, equalToInteger(PDGenderMale));
}

- (void) testUserLocation {
    assertThatFloat(user.location.latitude, closeTo(53.3313,0.01));
    assertThatFloat(user.location.longitude, closeTo(-6.2439,0.01));
}

- (void) testIdentifier {
    assertThatInteger(user.identifier, equalToInteger(1231));
}

- (void) testUserToken {
    assertThat(user.userToken, equalTo(@"hdgshsghwghgeygdyegdyge"));
}

- (void) testIsTester {

}

//Facebook Tests
- (void) testFacebookSocialAccountId {
    assertThatInteger(user.facebookParams.socialAccountId, equalToInteger(1234));
}

- (void) testFacebookIdentifier {
    assertThat(user.facebookParams.identifier, equalTo(@"123456789"));
}

- (void) testFacebookAccessToken {
    assertThat(user.facebookParams.accessToken, equalTo(@"facebokaccesstoken"));
}

- (void) testFacebookExpirationTime {
    assertThatLong(user.facebookParams.expirationTime, equalToLong(123456789));
}

- (void) testFacebookProfilePictureUrl {
    assertThat(user.facebookParams.profilePictureUrl, equalTo(@"https://imageurl.com"));
}

- (void) testFacebookScores {
    assertThatFloat(user.facebookParams.scores.total, closeTo(100.00, 0.01));
    assertThatFloat(user.facebookParams.scores.reach, closeTo(100.00, 0.01));
    assertThatFloat(user.facebookParams.scores.engagement, closeTo(100.00, 0.01));
    assertThatFloat(user.facebookParams.scores.frequency, closeTo(100.00, 0.01));
    assertThatFloat(user.facebookParams.scores.advocacy, closeTo(100.00, 0.01));
}


@end
