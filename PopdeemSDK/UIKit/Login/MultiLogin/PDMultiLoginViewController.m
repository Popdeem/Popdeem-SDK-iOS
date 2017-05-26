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
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *cancelButton;
@end

@implementation PDMultiLoginViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
  if (self = [self initWithNibName:@"PDMultiLoginViewController" bundle:podBundle]) {
    self.view.backgroundColor = [UIColor whiteColor];
    return self;
  }
  return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//View Setup
	_viewModel = [[PDMultiLoginViewModel alloc] initForViewController:self];
	[_viewModel setup];
	
	[_titleLabel setText:_viewModel.titleString];
	[_titleLabel setFont:_viewModel.titleFont];
	[_titleLabel setTextColor:_viewModel.titleColor];
  [_titleLabel sizeToFit];
	
	[_bodyLabel setText:_viewModel.bodyString];
	[_bodyLabel setTextColor:_viewModel.bodyColor];
	[_bodyLabel setFont:_viewModel.bodyFont];
	
	[_twitterLoginButton setBackgroundColor:_viewModel.twitterButtonColor];
	[_twitterLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  _twitterLoginButton.layer.cornerRadius = 5.0;
  _twitterLoginButton.clipsToBounds = YES;
	

  [_instagramLoginButton setBackgroundImage:[UIImage imageNamed:@"PDUI_IGBG"] forState:UIControlStateNormal];
	[_instagramLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  _instagramLoginButton.layer.cornerRadius = 5.0;
  _instagramLoginButton.clipsToBounds = YES;
	
	//Facebook setup
  _facebookLoginButton.layer.cornerRadius = 5.0;
  _facebookLoginButton.clipsToBounds = YES;
  [_facebookLoginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
  [self.facebookLoginButton.titleLabel setFont:PopdeemFont(PDThemeFontPrimary, 15)];
  
  if (_viewModel.image) {
    [self.imageView setImage:_viewModel.image];
  }
  [_imageView setContentMode:UIViewContentModeScaleAspectFill];
  _imageView.clipsToBounds = YES;
  
//  [self.facebookLoginButton.imageView setImage:nil];
  for (NSLayoutConstraint *l in self.facebookLoginButton.constraints) {
    if ( l.constant == 28 ){
      // Then disable it...
      l.active = false;
      break;
    }
  }
	
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
  _loadingView = [[PDUIModalLoadingView alloc] initWithDefaultsForView:self.view];
  _loadingView.titleLabel.text = @"Logging in.";
  [_loadingView showAnimated:YES];
	NSLog(@"Twitter Pressed");
	PDSocialMediaManager *manager = [[PDSocialMediaManager alloc] initForViewController:self];
	[manager registerWithTwitter:^{
		NSLog(@"Success");
		//Continue to next stage of app, login has happened.
		[self proceedWithTwitterLoggedInUser];
	} failure:^(NSError *error) {
		NSLog(@"Failure");
    dispatch_async(dispatch_get_main_queue(), ^{
      [_loadingView hideAnimated:YES];
    });
		//Show some error, something went wrong
	}];
}

- (IBAction)instagramLoginButtonPressed:(id)sender {
  _loadingView = [[PDUIModalLoadingView alloc] initWithDefaultsForView:self.view];
  _loadingView.titleLabel.text = @"Logging in.";
  [_loadingView showAnimated:YES];
	NSLog(@"Instagram Button Pressed");
	PDUIInstagramLoginViewController *instaVC = [[PDUIInstagramLoginViewController alloc] initForParent:self delegate:self connectMode:NO directConnect:YES];
	instaVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
	instaVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[self presentViewController:instaVC animated:YES completion:^(void){}];
}

- (void) proceedWithTwitterLoggedInUser {
  dispatch_async(dispatch_get_main_queue(), ^{
    [_loadingView hideAnimated:YES];
  });
	[self addUserToUserDefaults:[PDUser sharedInstance]];
	AbraLogEvent(ABRA_EVENT_LOGIN, @{@"Source" : @"Login Takeover"});
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) addUserToUserDefaults:(PDUser*)user {
	[[NSUserDefaults standardUserDefaults] setObject:[user dictionaryRepresentation] forKey:@"popdeemUser"];
}

#pragma mark - Instagram Login Delegate Methods

- (void) connectInstagramAccount:(NSString*)identifier accessToken:(NSString*)accessToken userName:(NSString*)userName {
	PDUserAPIService *service = [[PDUserAPIService alloc] init];
	
	[service registerUserWithInstagramId:identifier accessToken:accessToken fullName:@"" userName:userName profilePicture:@"" success:^(PDUser *user){
		[self addUserToUserDefaults:user];
		AbraLogEvent(ABRA_EVENT_LOGIN, @{@"Source" : @"Login Takeover"});
    dispatch_async(dispatch_get_main_queue(), ^{
      [_loadingView hideAnimated:YES];
      [self dismissViewControllerAnimated:YES completion:^{}];
    });
	} failure:^(NSError* error){
    dispatch_async(dispatch_get_main_queue(), ^{
      [_loadingView hideAnimated:YES];
    });
		NSLog(@"Failure to connect instagram");
	}];

}
- (IBAction)cancelButtonPressed:(id)sender {
  dispatch_async(dispatch_get_main_queue(), ^{
    [_loadingView hideAnimated:YES];
		});
	[self dismissAction:sender];
}

- (IBAction) dismissAction:(id)sender {
  dispatch_async(dispatch_get_main_queue(), ^{
    [_loadingView hideAnimated:YES];
  });
	[self dismissViewControllerAnimated:YES completion:^{
		//Any cleanup to do?
	}];
	AbraLogEvent(ABRA_EVENT_CLICKED_CLOSE_LOGIN_TAKEOVER, @{@"Source" : @"Dismiss Button"});
}

#pragma mark - Facebook Login -
- (IBAction) connectFacebook:(id)sender {
  self.facebookLoginOccurring = YES;
  _loadingView = [[PDUIModalLoadingView alloc] initWithDefaultsForView:self.view];
  _loadingView.titleLabel.text = @"Logging in.";
  [_loadingView showAnimated:YES];
  [[PDSocialMediaManager manager] loginWithFacebookReadPermissions:@[
                                                                     @"public_profile",
                                                                     @"email",
                                                                     @"user_birthday",
                                                                     @"user_posts",
                                                                     @"user_friends",
                                                                     @"user_education_history"]
                                               registerWithPopdeem:YES
                                                           success:^(void) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self facebookLoginSuccess];
                                                             });
                                                             
                                                           } failure:^(NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self facebookLoginFailure];
                                                             });
                                                           }];
}

- (void) facebookLoginSuccess {
  dispatch_async(dispatch_get_main_queue(), ^{
    [_loadingView hideAnimated:YES];
  });
  AbraLogEvent(ABRA_EVENT_LOGIN, @{@"Source" : @"Login Takeover"});
  [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) facebookLoginFailure {
  dispatch_async(dispatch_get_main_queue(), ^{
    [_loadingView hideAnimated:YES];
  });
  NSLog(@"Could not connect user to facebook");
}



@end
