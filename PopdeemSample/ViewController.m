//
//  ViewController.m
//  PopdeemSample
//
//  Created by John Doran Home on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "ViewController.h"
#import "PDSocialLoginViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#warning This is for testing

    PDSocialLoginViewController *loginVC = [[PDSocialLoginViewController alloc] initFromNib];
    [self addChildViewController:loginVC];
    [loginVC didMoveToParentViewController:self];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
