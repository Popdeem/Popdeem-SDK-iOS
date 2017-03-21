//
//  ViewController.m
//  BrandsSample
//
//  Created by Niall Quinn on 26/10/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "ViewController.h"
#import "PopdeemSDK.h"
#import "PDBrandApiService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)presentHere:(id)sender {
	[PopdeemSDK presentBrandFlowInNavigationController:self.navigationController];
	PDBrandApiService *service = [[PDBrandApiService alloc] init];
	[service getBrandByVendorSearchTerm:@"popdeem" completion:^(PDBrand *b, NSError *error) {
		NSLog(@"Brand Found: %@",b);
	}];
}

- (IBAction)presentForSearchTerm:(id)sender {
    UITextField *input = (UITextField*)sender;
    NSString *searchTerm = input.text;
    PDBrandApiService *service = [[PDBrandApiService alloc] init];
    [service getBrandByVendorSearchTerm:searchTerm completion:^(PDBrand *b, NSError *error) {
        if (error) {
            NSLog(@"Error: %@",error);
        }
        
    }];
}




@end
