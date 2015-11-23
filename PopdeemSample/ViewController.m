//
//  ViewController.m
//  PopdeemSample
//
//  Created by John Doran Home on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "ViewController.h"
#import "PDSocialLoginHandler.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PDSocialLoginHandler *loginHandler = [[PDSocialLoginHandler alloc] init];
    [loginHandler showPromptIfNeededWithMaxAllowed:@100];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
