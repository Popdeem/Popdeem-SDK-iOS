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
#import "PDAPIClient.h"
#import "PDUser.h"
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "Nocilla.h"

@interface PDSocialLoginViewModelTests : XCTestCase {
    PDSocialLoginViewModel *viewModel;
}

@end

@interface PDSocialLoginViewModel(TEST)
- (void) renderSuccess;
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations;
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
    OCMStub([mockController renderViewModelState]);
    [viewModel renderSuccess];
    expect(viewModel.loginState).to.equal(LoginStateContinue);
    expect(viewModel.titleLabelString).to.equal(@"Connected!");
    expect(viewModel.subTitleLabelString).to.equal(@"Rewards Available");
    expect(viewModel.descriptionLabelString).to.equal(@"Rewards are now unlocked. You will be notified when new rewards are available!");
    expect(viewModel.iconImageName).to.equal(@"pduikit_rewardsIconSuccess");
}

//- (void) testLocationDelegateDidUpdateSuccessfully {
//    id apiClientClassMock = [OCMockObject mockForClass:[PDAPIClient class]];
//    id testApiClientMock = OCMClassMock([PDAPIClient class]);
//    id locationManagerMock = OCMClassMock([PDGeolocationManager class]);
//    NSArray *locations = [NSArray arrayWithObject:[[CLLocation alloc] initWithLatitude:0 longitude:0]];
//    [viewModel setLoginState:LoginStateLogin];
//    void (^successBlock)(NSError *error) = ^void(NSError *error){
//        [viewModel setLoginState:LoginStateContinue];
//        expect(viewModel.loginState).to.equal(LoginStateContinue);
//    };
//    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
//        successBlock(nil);
//    };
//    
//    [[[apiClientClassMock stub] andReturn:testApiClientMock] sharedInstance];
//    [[[testApiClientMock stub] andDo:proxyBlock] updateUserLocationAndDeviceTokenSuccess:^(PDUser *user){} failure:^(NSError *error){}];
//    [viewModel locationManager:locationManagerMock didUpdateLocations:locations];
//}

@end
