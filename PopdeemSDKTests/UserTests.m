//
//  UserTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"
#import "PDUser.h"
#import "KWSpec+WaitFor.h"

SPEC_BEGIN(UserSpec)

describe(@"User", ^{

    context(@"init with mock JSON", ^{
        
        __block PDUser *u;
        
        beforeAll(^{
            NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"User" ofType:@"json"];
            NSString *userJSON = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [userJSON dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            
            u = [PDUser initFromAPI:json[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
        });
        
        it (@"first name should be John", ^{
            [[u.firstName should] equal:@"John"];
        });
        
        it (@"last name should be Doe", ^{
            [[u.lastName should] equal:@"Doe"];
        });
        
        it (@"gender should be male", ^{
            [[theValue(u.gender) should] equal:theValue(PDGenderMale)];
        });
        
        
        it (@"location should be 53.3313, -6.2439", ^{
            [[theValue((double)u.location.latitude) should] equal:53.3313 withDelta:0.01];
            [[theValue((double)u.location.longitude) should] equal:-6.2439 withDelta:0.01];
        });
        
        it (@"identifier should be 1231", ^{
            [[theValue(u.identifier) should] equal:theValue(1231)];
        });
        
        // Facebook Tests
        it (@"userToken should be hdgshsghwghgeygdyegdyge", ^{
            [[u.userToken should] equal:@"hdgshsghwghgeygdyegdyge"];
        });
        
        it (@"facebook ID should be 123456789", ^{
            [[u.facebookParams.identifier should] equal:@"123456789"];
        });
        
        it (@"facebook access token should be facebookaccesstoken", ^{
            [[u.facebookParams.accessToken should] equal:@"facebookaccesstoken"];
        });
        
        it (@"facebook social account id should be 1234", ^{
            [[theValue(u.facebookParams.socialAccountId) should] equal:theValue(1234)];
        });
        
        it (@"facebook expiration time should be (long)123456789", ^{
            [[theValue(u.facebookParams.expirationTime) should] equal:theValue(123456789)];
        });
        
        it (@"facebook profile picture url should be https://imageurl.com", ^{
            [[u.facebookParams.profilePictureUrl should] equal:@"https://imageurl.com"];
        });
        
        it (@"facebook scores", ^{
            [[theValue(u.facebookParams.scores.total) should] equal:100.0 withDelta:0.01];
            [[theValue(u.facebookParams.scores.reach) should] equal:100.0 withDelta:0.01];
            [[theValue(u.facebookParams.scores.engagement) should] equal:100.0 withDelta:0.01];
            [[theValue(u.facebookParams.scores.frequency) should] equal:100.0 withDelta:0.01];
            [[theValue(u.facebookParams.scores.advocacy) should] equal:100.0 withDelta:0.01];
        });
    });
});

SPEC_END
