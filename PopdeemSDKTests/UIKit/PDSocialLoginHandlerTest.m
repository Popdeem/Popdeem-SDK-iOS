//
//  PDSocialLoginHandlerTest.m
//  PopdeemSDK
//
//  Created by John Doran on 25/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PDUISocialLoginHandler.h"
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "PDSocialMediaManager.h"

@interface PDSocialLoginHandlerTest : XCTestCase {
  PDUISocialLoginHandler *loginHandler;
}
@end

@interface PDUISocialLoginHandler(TEST)
@property (nonatomic, strong) PDSocialMediaManager *socialManager;
@property (nonatomic, assign) NSUInteger maxPrompts;

- (BOOL)shouldShowPrompt;
@end

@implementation PDSocialLoginHandlerTest

- (void)setUp {
    [super setUp];
    loginHandler = [PDUISocialLoginHandler new];
}


//- (void)testShouldPromptLoginWhenNotUsed {
//    loginHandler.maxPrompts = 3;
//    loginHandler.usesCount = 0;
//
//    expect(([loginHandler shouldShowPrompt])).to.beTruthy();
//}
//
//- (void)testShouldNotPromptLoginWhenMoreThanMaxPrompts {
//    loginHandler.maxPrompts = 3;
//    loginHandler.usesCount = 4;
//    
//    expect(([loginHandler shouldShowPrompt])).to.beFalsy();
//}
//
//
//
//- (void)testShouldPromptLoginUserWhenIsNotLoggedIn {
//    loginHandler.maxPrompts = 3;
//    loginHandler.usesCount = 0;
//    
//    id mockManager = OCMClassMock([PDSocialMediaManager class]);
//    
//    loginHandler.socialManager = mockManager;
//    OCMStub([mockManager isLoggedIn]).andReturn(NO);
//    
//    expect(([loginHandler shouldShowPrompt])).to.beTruthy();
//}
//
//- (void)testShouldNotPromptLoginUserWhenIsLoggedIn {
//    loginHandler.maxPrompts = 3;
//    loginHandler.usesCount = 0;
//    
//    id mockManager = OCMClassMock([PDSocialMediaManager class]);
//
//    loginHandler.socialManager = mockManager;
//    OCMStub([mockManager isLoggedIn]).andReturn(YES);
//    
//    expect(([loginHandler shouldShowPrompt])).to.beFalsy();
//}

- (void)tearDown {
    [super tearDown];
}

@end
