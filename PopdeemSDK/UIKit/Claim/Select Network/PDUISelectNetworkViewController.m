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
#import "PDUserAPIService.h"
#import "PDBackgroundScan.h"
#import "PDUIPostScanViewController.h"


@interface PDUISelectNetworkViewController ()

@property (nonatomic, retain) NSArray *mediaTypes;
@property (nonatomic, retain) PDReward *reward;
@property (nonatomic, retain) PDBrand *brand;

@property (nonatomic) BOOL instagramLoggedIn;
@property (nonatomic) BOOL twitterLoggedIn;

@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *facebookButtonHC;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *twitterButtonHC;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *instagramButtonHC;
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
  
  //Determine what text to show at the top, depending on what networks can be used to scan.
  //TODO use new global hashtag when JD is done.
  NSString *topLabelText = @"";
  if (_mediaTypes.count > 1) {
    topLabelText = [NSString stringWithFormat:@"Choose what network you shared your experience with %@ to claim your reward:", _reward.forcedTag];
  } else {
    if ([_mediaTypes containsObject:@(PDSocialMediaTypeFacebook)]) {
      topLabelText = [NSString stringWithFormat:@"Scan Facebook for a story with %@ to claim your reward:", _reward.forcedTag];
    }
    if ([_mediaTypes containsObject:@(PDSocialMediaTypeTwitter)]) {
      topLabelText = [NSString stringWithFormat:@"Scan Twitter for a story with %@ to claim your reward:", _reward.forcedTag];
    }
    if ([_mediaTypes containsObject:@(PDSocialMediaTypeInstagram)]) {
      topLabelText = [NSString stringWithFormat:@"Scan Instagram for a story with %@ to claim your reward:", _reward.forcedTag];
    }
  }
  
  [self.topLabel setText:topLabelText];
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
    _twitterLoggedIn = YES;
    [self.twitterButton setTitle:@"Scan Twitter" forState:UIControlStateNormal];
  } else {
    _twitterLoggedIn = NO;
    [self.twitterButton setTitle:@"Connect to Twitter" forState:UIControlStateNormal];
  }
  
  [self.instagramButton.layer setCornerRadius:10.0];
  [self.instagramButton setBackgroundColor:[UIColor colorWithRed:0.27 green:0.39 blue:0.64 alpha:1.00]];
  [self.instagramButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  UIImage *igimage = [UIImage imageNamed:@"PDUI_IGBG"];
  if (igimage == nil) {
    NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
    NSString *imagePath = [podBundle pathForResource:@"PDUI_IGBG" ofType:@"png"];
    igimage = [UIImage imageWithContentsOfFile:imagePath];
  }
  [self.instagramButton setBackgroundImage:igimage forState:UIControlStateNormal];
  self.instagramButton.clipsToBounds = YES;
  

  //Just a dirty way to determine if a user is "logged in" with instagram. We verify the token later.
  if ([[[[PDUser sharedInstance] instagramParams] accessToken] length] > 0) {
    _instagramLoggedIn = YES;
    [self.instagramButton setTitle:@"Scan Instagram" forState:UIControlStateNormal];
  } else {
    _instagramLoggedIn = NO;
    [self.instagramButton setTitle:@"Connect to Instagram" forState:UIControlStateNormal];
  }

  //Verify the token for real. This takes a moment - above is to avoid the text on the button changing before the users eyes.
  [[PDSocialMediaManager manager] isLoggedInWithInstagram:^(BOOL isLoggedIn) {
    if (isLoggedIn) {
      _instagramLoggedIn = YES;
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.instagramButton setTitle:@"Scan Instagram" forState:UIControlStateNormal];
      });
    } else {
      _instagramLoggedIn = NO;
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.instagramButton setTitle:@"Connect to Instagram" forState:UIControlStateNormal];
      });
    }
  }];
  
  [self.bottomLabel setText:[NSString stringWithFormat:@"Note: You must have shared your experience with %@ in the last 48 hours to be eligible for a reward.", _reward.forcedTag]];
  [self.bottomLabel setTextColor:PopdeemColor(PDThemeColorSecondaryFont)];
  [self.bottomLabel setFont:PopdeemFont(PDThemeFontLight, 12)];
  
  
  //Hide the buttons that dont apply
  if (![_mediaTypes containsObject:@(PDSocialMediaTypeFacebook)]) {
    [self.facebookButton setHidden:YES];
    self.facebookButtonHC.constant = 0;
  }
  if (![_mediaTypes containsObject:@(PDSocialMediaTypeTwitter)]) {
    [self.twitterButton setHidden:YES];
    self.twitterButtonHC.constant = 0;
  }
  if (![_mediaTypes containsObject:@(PDSocialMediaTypeInstagram)]) {
    [self.instagramButton setHidden:YES];
    self.instagramButtonHC.constant = 0;
  }
  
  if (PopdeemThemeHasValueForKey(@"popdeem.images.tableViewBackgroundImage")) {
    UIImageView *tvbg = [[UIImageView alloc] initWithFrame:self.view.frame];
    [tvbg setImage:PopdeemImage(@"popdeem.images.tableViewBackgroundImage")];
    [self.view addSubview:tvbg];
    [self.view sendSubviewToBack:tvbg];
  }
  
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
    [self pushScanForNetwork:FACEBOOK_NETWORK];
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
    [self pushScanForNetwork:TWITTER_NETWORK];
  }];
}

- (IBAction)instagramButtonPressed:(id)sender {
  if (_instagramLoggedIn == YES) {
    [self pushScanForNetwork:INSTAGRAM_NETWORK];
  } else {
    [self connectInstagram];
  }
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
  [self pushScanForNetwork:INSTAGRAM_NETWORK];
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

- (void) connectInstagramAccount:(NSString*)identifier accessToken:(NSString*)accessToken userName:(NSString*)userName {
  PDAPIClient *client = [PDAPIClient sharedInstance];
  
  if ([[PDUser sharedInstance] isRegistered]) {
    [client connectInstagramAccount:identifier accessToken:accessToken screenName:userName success:^(void){
      [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginSuccess object:nil];
    } failure:^(NSError* error){
      dispatch_async(dispatch_get_main_queue(), ^{
        if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] rangeOfString:@"already connected"].location != NSNotFound) {
          UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry - Wrong Account" message:@"This social account has been linked to another user." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
          [av show];
          return;
        }
      });
      [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginFailure object:nil];
    }];
  } else {
    PDUserAPIService *service = [[PDUserAPIService alloc] init];
    [service registerUserWithInstagramId:identifier accessToken:accessToken fullName:@"" userName:userName profilePicture:@"" success:^(PDUser *user) {
      [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginSuccess object:nil];
    } failure:^(NSError *error) {
      [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginFailure object:nil];
    }];
  }
}

#pragma mark - Twitter Login -

- (void) connectTwitter {
  PDSocialMediaManager *manager = [[PDSocialMediaManager alloc] initForViewController:self];
  if ([[PDUser sharedInstance] isRegistered]) {
    [manager loginWithTwitter:^(void){
      //Twitter Connected Successfully
      PDLog(@"Twitter Logged in");
      [self twitterLoginSuccess];
    } failure:^(NSError *error) {
      if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] rangeOfString:@"already connected"].location != NSNotFound) {
        dispatch_async(dispatch_get_main_queue(), ^{
          UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry - Wrong Account" message:@"This social account has been linked to another user." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
          [av show];
          return;
        });
      } else {
        PDLogError(@"Twitter Not Logged in: %@",error.localizedDescription);
        [self twitterLoginFailure];
      }
    }];
  } else {
    [manager registerWithTwitter:^{
      //Twitter Connected Successfully
      PDLog(@"Twitter Logged in");
      PDLog(@"Twitter Logged in");
      [self twitterLoginSuccess];
    } failure:^(NSError *error) {
      PDLogError(@"Twitter Not Logged in: %@",error.localizedDescription);
      [self twitterLoginFailure];
      PDLogError(@"Twitter Not Logged in: %@",error.localizedDescription);
    }];
  }
}

- (void) twitterLoginSuccess {
  [self.twitterButton setTitle:@"Scan Twitter" forState:UIControlStateNormal];
  [self pushScanForNetwork:TWITTER_NETWORK];
}

- (void) twitterLoginFailure {
  PDLogError(@"Twitter didnt log in");
  UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.sorry", @"Sorry")
                                               message:translationForKey(@"popdeem.common.cantConnectTwitter", @"We couldnt connect you to Twitter")
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
  [self pushScanForNetwork:FACEBOOK_NETWORK];
  [self.facebookButton setTitle:@"Scan Facebook" forState:UIControlStateNormal];
}

- (void) facebookLoginFailure {
  [self.facebookButton setTitle:@"Connect to Facebook" forState:UIControlStateNormal];
  UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.sorry", @"Sorry")
                                               message:translationForKey(@"popdeem.common.cantConnectFacebook", @"We couldnt connect you to Facebook")
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:translationForKey(@"popdeem.common.ok", @"OK"), nil];
  [av show];
}

- (void) viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Scanning -

- (void) pushScanForNetwork:(NSString*)network {
  PDUIPostScanViewController *postScan = [[PDUIPostScanViewController alloc] initWithReward:_reward network:network];
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
  [self.navigationController pushViewController:postScan animated:YES];
}

@end
