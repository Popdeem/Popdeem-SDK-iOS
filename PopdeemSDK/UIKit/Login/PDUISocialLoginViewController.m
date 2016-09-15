//
//  PDSocialLoginViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PopdeemSDK.h"
#import "PDUISocialLoginViewController.h"
#import "PDUISocialLoginViewModel.h"
#import "PDSocialMediaManager.h"
#import "PDUIKitUtils.h"
#import "PDUtils.h"
#import "PDTheme.h"
#import "PDUser.h"

@interface PDUISocialLoginViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *poweredByLabel;

@end

@implementation PDUISocialLoginViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
  if (self = [self initWithNibName:@"PDUISocialLoginViewController" bundle:podBundle]) {
    self.view.backgroundColor = [UIColor clearColor];
    return self;
  }
  return nil;
}

- (instancetype) initWithLocationServices:(BOOL)shouldAskLocation {
  _shouldAskLocation = shouldAskLocation;
  return [self initFromNib];
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  self.viewModel = [[PDUISocialLoginViewModel alloc] init];
  [self.viewModel setViewController:self];
  self.loginButton.readPermissions= @[@"public_profile", @"email", @"user_birthday", @"user_posts", @"user_friends", @"user_education_history"];
  [self.loginButton setDelegate:self.viewModel];
  [self renderViewModelState];
  
  [self.taglineLabel setFont:PopdeemFont(PDThemeFontBold, 20)];
  [self.taglineLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
  
  [self.headingLabel setFont:PopdeemFont(PDThemeFontBold, 18)];
  [self.headingLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
  
  [self.bodylabel setFont:PopdeemFont(PDThemeFontPrimary, 14)];
  [self.bodylabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
  
  [self.termsLabel setFont:PopdeemFont(PDThemeFontPrimary, 7)];
  [self.termsLabel setTextColor:PopdeemColor(PDThemeColorSecondaryFont)];
	
	[self.continueButton.titleLabel setFont:PopdeemFont(PDThemeColorPrimaryFont, 15)];
  [self.continueButton setBackgroundColor:PopdeemColor(PDThemeColorPrimaryApp)];
  [self.continueButton setTitleColor:PopdeemColor(PDThemeColorPrimaryInverse) forState:UIControlStateNormal];
  
  self.imageView.clipsToBounds = YES;
}


- (void) viewDidAppear:(BOOL)animated {
  BOOL isLoggedIn = [[PDSocialMediaManager manager] isLoggedInWithFacebook];
  if (isLoggedIn && !_facebookLoginOccurring) {
    [_viewModel proceedWithLoggedInUser];
  }
	AbraLogEvent(ABRA_EVENT_VIEWED_LOGIN_TAKEOVER, nil);
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
  [parent.view addSubview:self.view];
  self.view.frame = parent.view.frame;
}

- (void) viewWillLayoutSubviews {
	
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
}

- (IBAction) dismissAction:(id)sender {
  [self dismissViewControllerAnimated:YES completion:^{
    //Any cleanup to do?
  }];
	AbraLogEvent(ABRA_EVENT_CLICKED_CLOSE_LOGIN_TAKEOVER, @{@"Source" : @"Dismiss Button"});
}

- (void) backingViewTapped {
  [self dismissViewControllerAnimated:YES completion:^{
    //Any cleanup to do?
  }];
	AbraLogEvent(ABRA_EVENT_CLICKED_CLOSE_LOGIN_TAKEOVER, @{@"Source" : @"Tapped Backing View"});
}

- (IBAction) continueAction:(id)sender {
  [self dismissViewControllerAnimated:YES completion:^{
    if(self.viewModel.loginState == LoginStateContinue){
      if([self.delegate respondsToSelector:@selector(loginDidSucceed)]){
        [self.delegate loginDidSucceed];
      }
    }
  }];
}

- (void) renderViewModelState {
  if (!_viewModel) return;
  [self.poweredByLabel setText:translationForKey(@"popdeem.sociallogin.footer", @"Powered by Popdeem")];
  [self.continueButton setTitle:translationForKey(@"popdeem.sociallogin.continue", @"Continue to App") forState:UIControlStateNormal];
  [self.taglineLabel setText:_viewModel.taglineString];
  [self.headingLabel setText:_viewModel.headingString];
  [self.bodylabel setText:_viewModel.bodyString];
  [self.imageView setImage:_viewModel.image];
  switch (_viewModel.loginState) {
    case LoginStateContinue:
      [self.loginButton setHidden:YES];
      [self.continueButton setHidden:NO];
      break;
    case LoginStateLogin:
    default:
      [self.loginButton setHidden:NO];
      [self.continueButton setHidden:YES];
      break;
      break;
  }
  [self.view setNeedsDisplay];
}

@end
