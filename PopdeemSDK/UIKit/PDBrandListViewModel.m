//
//  PDBrandListViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDBrandListViewModel.h"
#import "PDAPIClient.h"
#import "PDUIBrandsListTableViewController.h"

@implementation PDBrandListViewModel

- (instancetype) init {
	if (self = [super init]) {
		return self;
	}
	return nil;
}

- (void) fetchBrands {
	[[PDAPIClient sharedInstance] getBrandsSuccess:^(){
		[self getBrandsSuccess];
	} failure:^(NSError *error){
		[self getBrandsFailure:error];
	}];
}

- (void) getBrandsSuccess {
	PDLog(@"Fetch Brands Success");
	_tableData = [PDBrandStore orderedByDistanceFromUser];
	if ([_viewController.refreshControl isRefreshing]) {
		[_viewController.refreshControl endRefreshing];
	}
}

- (void) getBrandsFailure:(NSError*)error {
	PDLogError(@"Failure to get Brands: %@", error.localizedDescription);
	if ([_viewController.refreshControl isRefreshing]) {
		[_viewController.refreshControl endRefreshing];
	}
}

@end
