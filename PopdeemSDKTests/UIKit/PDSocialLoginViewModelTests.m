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
- (void) updateUserLocationCompletion:(void (^)(NSError *error))completion;
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations;
@end

@implementation PDSocialLoginViewModelTests

- (void) setUp {
//    viewModel = [[PDSocialLoginViewModel alloc] init];
}

- (void) tearDown {
    
}

- (void) testInitState {
//    expect(viewModel.loginState).to.equal(LoginStateLogin);
//  expect(viewModel.titleLabelString).to.equal(translationForKey(@"popdeem.sociallogin.title", @"App Update"));
//    expect(viewModel.subTitleLabelString).to.equal(@"Rewards Available");
//    expect(viewModel.descriptionLabelString).to.equal(@"To see what rewards you have unlocked, simply connect your Facebook account below.");
//    expect(viewModel.iconImageName).to.equal(@"pduikit_rewardsIcon");
}

- (void) testRenderSuccessState {
//    id mockController = OCMClassMock([PDSocialLoginViewController class]);
//    OCMStub([mockController renderViewModelState]);
//    [viewModel renderSuccess];
//    expect(viewModel.loginState).to.equal(LoginStateContinue);
//    expect(viewModel.titleLabelString).to.equal(translationForKey(@"popdeem.sociallogin.success", @"Connected!"));
//    expect(viewModel.subTitleLabelString).to.equal(@"Rewards Available");
//    expect(viewModel.descriptionLabelString).to.equal(translationForKey(@"popdeem.sociallogin.success.description", @"Rewards are now unlocked. You will be notified when new rewards are available!"));
//    expect(viewModel.iconImageName).to.equal(@"pduikit_rewardsIconSuccess");
}

- (void) testLocationDelegateDidUpdateSuccessfully {
//    id apiClientClassMock = [OCMockObject mockForClass:[PDAPIClient class]];
//    id testApiClientMock = OCMClassMock([PDAPIClient class]);
//    id locationManagerMock = OCMClassMock([PDGeolocationManager class]);
//    
//    id viewModelMock = OCMClassMock([PDSocialLoginViewModel class]);
//    
//    NSArray *locations = [NSArray arrayWithObject:[[CLLocation alloc] initWithLatitude:0 longitude:0]];
//    [viewModel setLoginState:LoginStateLogin];

}

@end
