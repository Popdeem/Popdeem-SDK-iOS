//
//  PDUICordovaNavigationController.m
//  PopdeemSDK
//
//  Created by niall quinn on 25/09/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import "PDUICordovaNavigationController.h"

@interface PDUICordovaNavigationController ()

@end

@implementation PDUICordovaNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) loadView {
	[super loadView];
//	UIBarButton *bbItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(@"dismiss")];
//	self.navigationItem.leftBarButtonItem = bbItem;
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
