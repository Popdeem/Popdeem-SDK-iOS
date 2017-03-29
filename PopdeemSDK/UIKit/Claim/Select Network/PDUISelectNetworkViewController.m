//
//  PDUISelectNetworkViewController.m
//  PopdeemSDK
//
//  Created by niall quinn on 29/03/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import "PDUISelectNetworkViewController.h"
#import "PDTheme.h"
#import "PDConstants.h"
#import "PDUtils.h"
#import "PopdeemSDK.h"
#import "PDSocialMediaManager.h"
#import "PDUIFBLoginWithWritePermsViewController.h"
#import "PDUITwitterLoginViewController.h"
#import "PDAPIClient.h"


@interface PDUISelectNetworkViewController ()

@property (nonatomic, retain) NSArray *mediaTypes;
@property (nonatomic, retain) PDReward *reward;
@property (nonatomic, retain) PDBrand *brand;

@end

@implementation PDUISelectNetworkViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
  if (self = [self initWithNibName:@"PDUISelectNetworkViewController" bundle:podBundle]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Scan";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginSuccess) name:InstagramLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginFailure) name:InstagramLoginFailure object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginUserDismissed) name:InstagramLoginuserDismissed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoginSuccess) name:FacebookLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoginFailure) name:FacebookLoginFailure object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterLoginSuccess) name:TwitterLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterLoginFailure) name:TwitterLoginFailure object:nil];
    return self;
  }
  return nil;
}

- (id) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward brand:(PDBrand*)brand {
  if (self = [self initFromNib]) {
    _mediaTypes = mediaTypes;
    _reward = reward;
    _brand = brand;
    return self;
  }
  return nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.topLabel setText:[NSString stringWithFormat:@"Choose what network you shared your experience with %@ to claim your reward:", _reward.instagramForcedTag]];
  [self.topLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
  [self.topLabel setFont:PopdeemFont(PDThemeFontPrimary, 14)];
  
  [self.facebookButton.layer setCornerRadius:10.0];
  [self.facebookButton setBackgroundColor:[UIColor colorWithRed:0.27 green:0.39 blue:0.64 alpha:1.00]];
  [self.facebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
  if ([[PDSocialMediaManager manager] isLoggedInWithFacebook]) {
    [self.facebookButton setTitle:@"Scan Facebook" forState:UIControlStateNormal];
  } else {
    [self.facebookButton setTitle:@"Connect to Facebook" forState:UIControlStateNormal];
  }
  
  [self.twitterButton.layer setCornerRadius:10.0];
  [self.twitterButton setBackgroundColor:[UIColor colorWithRed:0.13 green:0.67 blue:0.96 alpha:1.00]];
  [self.twitterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
  if ([[PDSocialMediaManager manager] isLoggedInWithTwitter]) {
    [self.twitterButton setTitle:@"Scan Twitter" forState:UIControlStateNormal];
  } else {
    [self.twitterButton setTitle:@"Connect to Twitter" forState:UIControlStateNormal];
  }
  
  [self.instagramButton.layer setCornerRadius:10.0];
  [self.instagramButton setBackgroundColor:[UIColor colorWithRed:0.27 green:0.39 blue:0.64 alpha:1.00]];
  [self.instagramButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.instagramButton setBackgroundImage:[UIImage imageNamed:@"PDUI_IGBG"] forState:UIControlStateNormal];
  
  [[PDSocialMediaManager manager] isLoggedInWithInstagram:^(BOOL isLoggedIn) {
    if (isLoggedIn) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.instagramButton setTitle:@"Scan Instagram" forState:UIControlStateNormal];
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.instagramButton setTitle:@"Connect to Instagram" forState:UIControlStateNormal];
      });
    }
  }];
  
  [self.bottomLabel setText:[NSString stringWithFormat:@"Note: You must have shared your experience with the %@ in the last 48 hours to be eligible for a reward.", _reward.instagramForcedTag]];
  [self.bottomLabel setTextColor:PopdeemColor(PDThemeColorSecondaryFont)];
  [self.bottomLabel setFont:PopdeemFont(PDThemeFontLight, 12)];
  
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

- (IBAction)facebookButtonPressed:(id)sender {
  if ([[PDSocialMediaManager manager] isLoggedInWithFacebook]) {
    //Go to scan page
    return;
  }
  //Connect to Facebook and then scan
  [self connectFacebook];
}

- (IBAction)twitterButtonPressed:(id)sender {
  [[PDSocialMediaManager manager] verifyTwitterCredentialsCompletion:^(BOOL connected, NSError *error) {
    if (!connected) {
      [self connectTwitter];
      return;
    }
    //TODO: Segue to Scan
  }];
}

- (IBAction)instagramButtonPressed:(id)sender {
  [[PDSocialMediaManager manager] isLoggedInWithInstagram:^(BOOL isLoggedIn) {
    if (isLoggedIn) {
      //TODO: Segue to Scan
    } else {
      [self connectInstagram];
    }
  }];
}

#pragma mark - Instagram Login -

- (void) connectInstagram {
  dispatch_async(dispatch_get_main_queue(), ^{
				PDUIInstagramLoginViewController *instaVC = [[PDUIInstagramLoginViewController alloc] initForParent:self.navigationController delegate:self connectMode:YES directConnect:YES];
				if (!instaVC) {
          return;
        }
    
				self.definesPresentationContext = YES;
				instaVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
				instaVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
				[self presentViewController:instaVC animated:YES completion:^(void){}];
  });
}

- (void) instagramLoginSuccess {
  [self.instagramButton setTitle:@"Scan Instagram" forState:UIControlStateNormal];
  PDLog(@"Instagram Connected");
  AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
                                                ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_INSTAGRAM,
                                                ABRA_PROPERTYNAME_SOURCE_PAGE : @"Claim Screen"
                                                }));
}

- (void) instagramLoginUserDismissed {
  
}

- (void) instagramLoginFailure {

  UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                               message:@"There was a problem connecting your Instagram Account. Please try again later."
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
  [av show];
}

- (void) connectInstagramAccount:(NSInteger)identifier accessToken:(NSString*)accessToken userName:(NSString*)userName {
  PDAPIClient *client = [PDAPIClient sharedInstance];
  [client connectInstagramAccount:identifier accessToken:accessToken screenName:userName success:^(void){
    [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginSuccess object:nil];
  } failure:^(NSError* error){
    [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginFailure object:nil];
  }];
}

#pragma mark - Twitter Login -

- (void) connectTwitter {
  PDSocialMediaManager *manager = [[PDSocialMediaManager alloc] initForViewController:self];
  [manager loginWithTwitter:^(void){
    //Twitter Connected Successfully
    PDLog(@"Twitter Logged in");
    [self twitterLoginSuccess];
  } failure:^(NSError *error) {
    [self twitterLoginFailure];
    PDLogError(@"Twitter Not Logged in: %@",error.localizedDescription);
  }];
}

- (void) twitterLoginSuccess {
  [self.twitterButton setTitle:@"Scan Twitter" forState:UIControlStateNormal];
  //TODO: Segue to Scan
}

- (void) twitterLoginFailure {
  PDLogError(@"Twitter didnt log in");
  UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.sorry", @"Sorry")
                                               message:@"We couldnt connect you to Twitter"
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:translationForKey(@"popdeem.common.ok", @"OK"), nil];
  [av show];
}

#pragma mark - Facebook Login -
- (void) connectFacebook {
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
  //TODO: Segue to Scan here
  NSLog(@"Connected Facebook");
  [self.facebookButton setTitle:@"Scan Facebook" forState:UIControlStateNormal];
}

- (void) facebookLoginFailure {
  [self.facebookButton setTitle:@"Connect to Facebook" forState:UIControlStateNormal];
  UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.sorry", @"Sorry")
                                               message:translationForKey(@"popdeem.claim.facebook.connect", @"We couldnt connect you to Facebook")
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:translationForKey(@"popdeem.common.ok", @"OK"), nil];
  [av show];
}

- (void) viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
