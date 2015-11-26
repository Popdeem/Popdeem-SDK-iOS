//
//  PDSocialLoginViewModelTests.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PDSocialLoginViewModel.h"
#import "PDSocialLoginViewController.h"
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

@interface PDSocialLoginViewModelTests : XCTestCase {
    PDSocialLoginViewModel *viewModel;
}

@end

@interface PDSocialLoginViewModel(TEST)
- (void) renderSuccess;
@end

@implementation PDSocialLoginViewModelTests

- (void) setUp {
    viewModel = [[PDSocialLoginViewModel alloc] init];
}

- (void) tearDown {
    
}

- (void) testInitState {
    expect(viewModel.loginState).to.equal(LoginStateLogin);
    expect(viewModel.titleLabelString).to.equal(@"App Update");
    expect(viewModel.subTitleLabelString).to.equal(@"Rewards Available");
    expect(viewModel.descriptionLabelString).to.equal(@"To see what rewards you have unlocked, simply connect your Facebook account below.");
    expect(viewModel.iconImageName).to.equal(@"pduikit_rewardsIcon");
}

- (void) testRenderSuccessState {
    id mockController = OCMClassMock([PDSocialLoginViewController class]);
    OCMStub([mockController render]);
    [viewModel renderSuccess];
    expect(viewModel.loginState).to.equal(LoginStateContinue);
    expect(viewModel.titleLabelString).to.equal(@"Connected!");
    expect(viewModel.subTitleLabelString).to.equal(@"Rewards Available");
    expect(viewModel.descriptionLabelString).to.equal(@"Rewards are now unlocked. You will be notified when new rewards are available!");
    expect(viewModel.iconImageName).to.equal(@"pduikit_rewardsIconSuccess");
}

@end
