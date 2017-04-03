//
//  PDUIPostScanViewController.m
//  PopdeemSDK
//
//  Created by niall quinn on 03/04/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import "PDUIPostScanViewController.h"

@interface PDUIPostScanViewController ()

@end

@implementation PDUIPostScanViewController

- (instancetype) initWithModel:(PDBGScanResponseModel*)model {
  
}

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
  if (self = [self initWithNibName:@"PDUIPostScanViewController" bundle:podBundle]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Claim";
    return self;
  }
  return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
