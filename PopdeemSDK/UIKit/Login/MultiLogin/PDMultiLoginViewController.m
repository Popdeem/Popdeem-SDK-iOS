//
//  PDMultiLoginViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/01/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import "PDMultiLoginViewController.h"
#import "PDSocialMediaManager.h"
#import "PDMultiLoginViewModel.h"
#import "PDTheme.h"
#import "PDConstants.h"
#import "PDUser.h"
#import "PDAbraClient.h"
#import "PDUser+Facebook.h"
#import "PDLogger.h"
#import "PDUtils.h"
#import "PDUserAPIService.h"
#import "PDAPIClient.h"
#import "PDUIInstagramLoginViewController.h"

@interface PDMultiLoginViewController ()
@property (nonatomic, retain) PDMultiLoginViewModel* viewModel;
@property (nonatomic) BOOL facebookLoginOccurring;
@end

@implementation PDMultiLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//View Setup
	_viewModel = [[PDMultiLoginViewModel alloc] initForViewController:self];
	[_viewModel setup];
	
	[_titleLabel setText:_viewModel.titleString];
	[_titleLabel setFont:_viewModel.titleFont];
	[_titleLabel setTextColor:_viewModel.titleColor];
	
	[_bodyLabel setText:_viewModel.bodyString];
	[_bodyLabel setTextColor:_viewModel.bodyColor];
	[_bodyLabel setFont:_viewModel.bodyFont];
	
	[_twitterLoginButton setBackgroundColor:_viewModel.twitterButtonColor];
	[_twitterLoginButton setTitleColor:PopdeemColor(PDThemeColorPrimaryInverse) forState:UIControlStateNormal];
	
	[_instagramLoginButton setBackgroundColor:_viewModel.instagramButtonColor];
	[_instagramLoginButton setTitleColor:PopdeemColor(PDThemeColorPrimaryInverse) forState:UIControlStateNormal];
	
	//Facebook setup
	self.facebookLoginButton.readPermissions = @[@"public_profile", @"email", @"user_birthday", @"user_posts", @"user_friends", @"user_education_history"];
	[self.facebookLoginButton setDelegate:self];
	
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)twitterLoginButtonPressed:(id)sender {
	NSLog(@"Twitter Pressed");
	PDSocialMediaManager *manager = [[PDSocialMediaManager alloc] initForViewController:self];
	[manager registerWithTwitter:^{
		NSLog(@"Success");
		//Continue to next stage of app, login has happened.
		dispatch_async(dispatch_get_main_queue(), ^{
			[_loadingView hideAnimated:YES];
		});
		[self proceedWithTwitterLoggedInUser];
	} failure:^(NSError *error) {
		NSLog(@"Failure");
		//Show some error, something went wrong
	}];
}

- (IBAction)instagramLoginButtonPressed:(id)sender {
	NSLog(@"Instagram Button Pressed");
	PDUIInstagramLoginViewController *instaVC = [[PDUIInstagramLoginViewController alloc] initForParent:self delegate:self connectMode:NO];
	instaVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
	instaVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[self presentViewController:instaVC animated:YES completion:^(void){}];
}

- (void) proceedWithTwitterLoggedInUser {
	[self addUserToUserDefaults:[PDUser sharedInstance]];
	AbraLogEvent(ABRA_EVENT_LOGIN, @{@"Source" : @"Login Takeover"});
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) proceedWithFacebookLoggedInUser {
	//Now Facebook Login has happened, we should perform register/fetch from Popdeem
	self.loadingView = [[PDUIModalLoadingView alloc] initWithDefaultsForView:self.view];
	[self.loadingView showAnimated:YES];
	
	[[PDUser sharedInstance] refreshFacebookFriendsCallback:^(BOOL response){
		PDLog(@"Facebook Friends Updated");
	}];
	[[PDSocialMediaManager manager] nextStepForFacebookLoggedInUser:^(NSError *error) {
		if (error) {
			PDLogError(@"Something went wrong: %@",error);
			[[PDSocialMediaManager manager] logoutFacebook];
			dispatch_async(dispatch_get_main_queue(), ^{
				[_loadingView hideAnimated:YES];
			});
			return;
		}
		[self addUserToUserDefaults:[PDUser sharedInstance]];
		dispatch_async(dispatch_get_main_queue(), ^{
			[_loadingView hideAnimated:YES];
		});
		[self dismissViewControllerAnimated:YES completion:^{}];
		AbraLogEvent(ABRA_EVENT_LOGIN, @{@"Source" : @"Login Takeover"});
	}];
}

#pragma mark - FB Login Delegate Methods -
- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
	//Perform Popdeem User Login
	if (error) {
		//Show error message
		return;
	}
	
	if (result.isCancelled) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.facebookLoginCancelledTitle",@"Login Cancelled.")
																								 message:translationForKey(@"popdeem.common.facebookLoginCancelledBody",@"You must log in with Facebook to avail of social rewards.")
																								delegate:self
																			 cancelButtonTitle:@"OK"
																			 otherButtonTitles: nil];
		[av show];
		return;
	}
	
	[self proceedWithFacebookLoggedInUser];
}

- (BOOL) loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
	self.facebookLoginOccurring = YES;
	return YES;
}

- (void) addUserToUserDefaults:(PDUser*)user {
	[[NSUserDefaults standardUserDefaults] setObject:[user dictionaryRepresentation] forKey:@"popdeemUser"];
}

- (void) registerWithModel:(InstagramResponseModel*)model {
	self.loadingView = [[PDUIModalLoadingView alloc] initWithDefaultsForView:self.view];
	[self.loadingView showAnimated:YES];
	PDUserAPIService *service = [[PDUserAPIService alloc] init];
//	service registerUserWithInstagramId:model.user.id accessToken:<#(NSString *)#> fullName:<#(NSString *)#> userName:<#(NSString *)#> profilePicture:<#(NSString *)#> success:<#^(PDUser *user)success#> failure:<#^(NSError *error)failure#>
	
}

#pragma mark - Instagram Login Delegate Methods

- (void) connectInstagramAccount:(NSInteger)identifier accessToken:(NSString*)accessToken userName:(NSString*)userName {
	PDUserAPIService *service = [[PDUserAPIService alloc] init];
	
	[service registerUserWithInstagramId:identifier accessToken:accessToken fullName:@"" userName:userName profilePicture:@"" success:^(PDUser *user){
		[self addUserToUserDefaults:user];
		AbraLogEvent(ABRA_EVENT_LOGIN, @{@"Source" : @"Login Takeover"});
		[self dismissViewControllerAnimated:YES completion:^{}];
	} failure:^(NSError* error){
		NSLog(@"Failure to connect instagram");
	}];

}

@end
