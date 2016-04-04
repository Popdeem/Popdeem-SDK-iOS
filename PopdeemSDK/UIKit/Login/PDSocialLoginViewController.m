//
//  PDSocialLoginViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDSocialLoginViewController.h"
#import "PDSocialLoginViewModel.h"
#import "PDSocialMediaManager.h"
#import "PDUIKitUtils.h"
#import "PDUtils.h"
#import "PDTheme.h"
#import "PDUser.h"

@interface PDSocialLoginViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *poweredByLabel;

@end

@implementation PDSocialLoginViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDSocialLoginViewController" bundle:podBundle]) {
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
  self.viewModel = [[PDSocialLoginViewModel alloc] init];
  [self.viewModel setViewController:self];
  self.loginButton.readPermissions= @[@"public_profile", @"email", @"user_birthday", @"user_posts", @"user_friends", @"user_education_history"];
  [self.loginButton setDelegate:self.viewModel];
  self.imageView.backgroundColor = PopdeemColor(@"popdeem.login.imageView.backgroundColor");
  [self renderViewModelState];
  
  [self.taglineLabel setFont:PopdeemFont(@"popdeem.login.tagline.font", 15)];
  [self.taglineLabel setTextColor:PopdeemColor(@"popdeem.login.tagline.color")];
  
  [self.headingLabel setFont:PopdeemFont(@"popdeem.login.heading.font", 18)];
  [self.headingLabel setTextColor:PopdeemColor(@"popdeem.login.heading.color")];
  
  [self.bodylabel setFont:PopdeemFont(@"popdeem.login.body.font", 14)];
  [self.bodylabel setTextColor:PopdeemColor(@"popdeem.login.body.color")];
  
  [self.termsLabel setFont:PopdeemFont(@"popdeem.login.terms.font", 7)];
  [self.termsLabel setTextColor:PopdeemColor(@"popdeem.login.terms.color")];
  
  [self.continueButton setBackgroundColor:PopdeemColor(@"popdeem.login.continueButton.background")];
  [self.continueButton setTitleColor:PopdeemColor(@"popdeem.login.continueButton.textColor") forState:UIControlStateNormal];
  
  self.imageView.clipsToBounds = YES;
}

- (void) viewDidAppear:(BOOL)animated {
  BOOL isLoggedIn = [[PDSocialMediaManager manager] isLoggedInWithFacebook];
  if (isLoggedIn && !_facebookLoginOccurring) {
    [_viewModel proceedWithLoggedInUser];
  }
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
  [parent.view addSubview:self.view];
  self.view.frame = parent.view.frame;
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
}

- (IBAction) dismissAction:(id)sender {
  [self dismissViewControllerAnimated:YES completion:^{
    //Any cleanup to do?
  }];
}

- (void) backingViewTapped {
  [self dismissViewControllerAnimated:YES completion:^{
    //Any cleanup to do?
  }];
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
