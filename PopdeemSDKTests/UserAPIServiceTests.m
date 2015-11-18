//
//  UserAPIServiceTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"
#import "PDUserAPIService.h"

SPEC_BEGIN(UserAPIServiceTest)

describe(@"User API Service", ^{
    
    __block PDUserAPIService *_apiService;
    
    beforeAll(^{
        _apiService = [[PDUserAPIService alloc] init];
    });
    
    context(@"register", ^{
        it(@"should send a request to the correct url", ^{
            KWCaptureSpy *requestSpy = [NSURLSession captureArgument:@selector(dataTaskWithRequest:completionHandler:) atIndex:0];
            [_apiService registerUserwithFacebookAccesstoken:@"" facebookId:@"" completion:^(PDUser *user, NSError *error){}];
            NSURLRequest *req = requestSpy.argument;
            [req shouldNotBeNil];
            [[[req.URL absoluteString] should] equal:@""];
        });
    });
});


SPEC_END

