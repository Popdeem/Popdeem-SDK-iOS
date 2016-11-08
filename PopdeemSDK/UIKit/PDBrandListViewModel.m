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
	if (_viewController.isLoading) {
		_viewController.isLoading = NO;
	}
	_tableData = [[PDBrandStore orderedByDistanceFromUser] mutableCopy];
	for (int i = 0 ; i < _tableData.count ; i++) {
		PDBrand *b = _tableData[i];
		if (b.numberOfRewardsAvailable == 0) {
			[_tableData removeObjectAtIndex:i];
			i--;
		}
	}
	[_viewController.tableView reloadData];
	if ([_viewController.refreshControl isRefreshing]) {
		[_viewController.refreshControl endRefreshing];
	}
}

- (void) getBrandsFailure:(NSError*)error {
	PDLogError(@"Failure to get Brands: %@", error.localizedDescription);
	if ([_viewController.refreshControl isRefreshing]) {
		[_viewController.refreshControl endRefreshing];
	}
	if (_viewController.isLoading) {
		_viewController.isLoading = NO;
	}
	[_viewController.tableView reloadData];
}

@end
