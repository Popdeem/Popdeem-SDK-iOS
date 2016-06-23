//
//  PDUIInstagramVerifyViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIInstagramVerifyViewController.h"
#import "PDReward.h"

@interface PDUIInstagramVerifyViewController ()

@end

@implementation PDUIInstagramVerifyViewController

- (instancetype) initForParent:(UIViewController*)parent forReward:(PDReward*)reward {
	if (self = [super init]) {
		_parent = parent;
		return self;
	}
	return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
