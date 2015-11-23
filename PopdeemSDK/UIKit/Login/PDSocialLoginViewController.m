//
//  PDSocialLoginViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDSocialLoginViewController.h"

@interface PDSocialLoginViewController ()

@end

@implementation PDSocialLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[PDSocialLoginViewModel alloc] init];
    [_loginButton setDelegate:_viewModel];
    
    //Backing View Dismiss Recogniser
    UITapGestureRecognizer *backingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backingViewTapped)];
    [_backingView addGestureRecognizer:backingTap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
    
}

- (void) backingViewTapped {
    [self dismissViewControllerAnimated:YES completion:^{
        //Any cleanup to do?
    }];
}

@end
