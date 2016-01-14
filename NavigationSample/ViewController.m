//
//  ViewController.m
//  NavigationSample
//
//  Created by Niall Quinn on 04/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "ViewController.h"
#import "PopdeemSDK.h"
#import "PDRewardHomeTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction) pushIt:(id)sender {
  [self.navigationController pushViewController:[[PDRewardHomeTableViewController alloc] initFromNib] animated:YES];
}

- (IBAction) popIt:(id)sender {
  [PopdeemSDK presentRewardFlow];
}

@end
