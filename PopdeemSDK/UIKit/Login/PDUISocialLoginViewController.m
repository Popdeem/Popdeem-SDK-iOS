//
//  PDSocialLoginViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

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
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
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
  
  [self.taglineLabel setFont:PopdeemFont(@"popdeem.fonts.boldFont", 20)];
  [self.taglineLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryFontColor")];
  
  [self.headingLabel setFont:PopdeemFont(@"popdeem.fonts.boldFont", 18)];
  [self.headingLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryFontColor")];
  
  [self.bodylabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 14)];
  [self.bodylabel setTextColor:PopdeemColor(@"popdeem.colors.secondaryFontColor")];
  
  [self.termsLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 7)];
  [self.termsLabel setTextColor:PopdeemColor(@"popdeem.colors.secondaryFontColor")];
	
	[self.continueButton.titleLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 15)];
  [self.continueButton setBackgroundColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
  [self.continueButton setTitleColor:PopdeemColor(@"popdeem.colors.primaryInverseColor") forState:UIControlStateNormal];
  
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

- (void) viewWillLayoutSubviews {
	
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
