//
//  SecondTabViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 12/04/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "SecondTabViewController.h"
#import "PopdeemSDK.h"

@interface SecondTabViewController ()

@end

@implementation SecondTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testTrigger:(id)sender {
  [PopdeemSDK logMoment:@"post_payment"];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
