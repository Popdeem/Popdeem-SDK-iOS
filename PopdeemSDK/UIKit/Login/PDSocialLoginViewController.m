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

@interface PDSocialLoginViewController () {
}


@end

@implementation PDSocialLoginViewController

- (id) initFromNib {
    NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
    if (self = [self initWithNibName:@"PDSocialLoginViewController" bundle:podBundle]) {
        self.view.backgroundColor = [UIColor clearColor];
        return self;
    }
    return nil;
}

- (id) initWithLocationServices:(BOOL)shouldAskLocation {
    _shouldAskLocation = shouldAskLocation;
    return [self initFromNib];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _viewModel = [[PDSocialLoginViewModel alloc] init];
    [_viewModel setViewController:self];
    [_loginButton setDelegate:_viewModel];
    _snapshotView.image = [PDUIKitUtils screenSnapshot];
    //Backing View Dismiss Recogniser
    UITapGestureRecognizer *backingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backingViewTapped)];
    [_backingView addGestureRecognizer:backingTap];
    [self renderViewModelState];

}

- (void) viewDidAppear:(BOOL)animated {
    BOOL isLoggedIn = [[PDSocialMediaManager manager] isLoggedInWithFacebook];
    if (isLoggedIn && !_facebookLoginOccurring) {
        [_viewModel proceedWithLoggedInUser];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
    [parent.view addSubview:self.view];
    self.view.frame = parent.view.frame;
}

- (void) viewWillLayoutSubviews {
    
}

- (void) backingViewTapped {
    [self dismissViewControllerAnimated:YES completion:^{
        //Any cleanup to do?
    }];
}

- (IBAction) continueAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) renderViewModelState {
    if (!_viewModel) return;
    [self.titleLabel setText:_viewModel.titleLabelString];
    [self.subtitleLabel setText:_viewModel.subTitleLabelString];
    [self.descriptionLabel setText:_viewModel.descriptionLabelString];
    [self.iconView setImage:[UIImage imageNamed:_viewModel.iconImageName]];
    switch (_viewModel.loginState) {
        case LoginStateContinue:
            [self.loginButton setHidden:YES];
            [self.continueButton setHidden:NO];
            [_titleLabel setTextColor:[UIColor colorWithRed:0.184 green:0.553 blue:0.000 alpha:1.000]];
            break;
        case LoginStateLogin:
        default:
            [self.loginButton setHidden:NO];
            [self.continueButton setHidden:YES];
            [_titleLabel setTextColor:[UIColor colorWithRed:0.745 green:0.251 blue:0.286 alpha:1.000]];
            break;
            break;
    }
    [self.view setNeedsDisplay];
}

@end
