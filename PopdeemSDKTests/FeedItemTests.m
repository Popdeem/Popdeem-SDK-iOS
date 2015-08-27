//
//  FeedItemTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "PDFeedItem.h"

@interface FeedItemTests : XCTestCase {
    PDFeedItem *feedItem;
}

@end

@implementation FeedItemTests

- (void)setUp {
    [super setUp];
    
    NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"PDFeedItem_WithPicture" ofType:@"json"];
    NSString *userJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [userJSON dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [[NSError alloc] init];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    
    feedItem = [[PDFeedItem alloc] initFromAPI:json];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testBrandName {
    assertThat(feedItem.brandName, equalTo(@"Popdeem Bakery"));
}

- (void) testBrandLogo {
    assertThat(feedItem.brandLogoUrlString, equalTo(@"http://s3-eu-west-1.amazonaws.com/popdeem-staging/brands/logo_images/000/000/010/original/popdeem_logo.png?1370879332"));
}

- (void) testRewardType {
    assertThat(feedItem.rewardTypeString, equalTo(@"coupon"));
}

- (void) testRewardDescription {
    assertThat(feedItem.descriptionString, equalTo(@"Free Coffee"));
}

- (void) testTimeAgo {
    assertThat(feedItem.timeAgoString, equalTo(@"10 months ago"));
}

- (void) testPictureUrl {
    assertThat(feedItem.imageUrlString, equalTo(@"http://s3-eu-west-1.amazonaws.com/popdeem-staging/requests/photos/000/000/455/original/455.png?1413206567"));
}

- (void) testUserName {
    assertThat(feedItem.userFirstName, equalTo(@"Niall"));
    assertThat(feedItem.userLastName, equalTo(@"Quinn"));
}

- (void) testUserIdentifier {
    assertThatInteger(feedItem.userId, equalToInteger(1231));
}

- (void) testUserProfilePic {
    assertThat(feedItem.userProfilePicUrlString, equalTo(@"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/p200x200/10561791_10152587847771069_6128016419296960032_n.jpg?oh=dfcfc553c9aaf041416d0860c08d2c43&oe=561003BD&__gda__=1444320298_77b07a28640de42951ba6293df2e9621"));
}

@end
