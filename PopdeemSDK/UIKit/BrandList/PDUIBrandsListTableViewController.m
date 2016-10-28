//
//  PDUIBrandsListTableViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIBrandsListTableViewController.h"
#import "PopdeemSDK.h"
#import "PDUIBrandPlaceHolderTableViewCell.h"
#import "PDUIBrandTableViewCell.h"
#import "PDTheme.h"
#import "PDBrand.h"
#import "PDUIHomeViewController.h"

#define kBrandCell @"BrandCell"
#define kSearchCell @"SearchCell"
#define kPlaceHolderCell @"PlaceholderCell"

@interface PDUIBrandsListTableViewController () {
	BOOL searchMode;
	BOOL searchEnabled;
	CGRect keyboardRect;
	BOOL firstLoad;
}

@property (nonatomic, retain) NSMutableArray *searchData;
@property (nonatomic, retain) UISearchBar *searchBar;
//@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end


@implementation PDUIBrandsListTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	searchEnabled = NO;
	searchMode = NO;
	_isLoading = YES;
	firstLoad = YES;
	// Uncomment the following line to preserve selection between presentations.
	// self.clearsSelectionOnViewWillAppear = NO;
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	UIBarButtonItem *searchbb = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemSearch) target:self action:@selector(searchTapped)];
	self.navigationItem.rightBarButtonItem = searchbb;
	
	NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
	
	UINib *brandNib = [UINib nibWithNibName:@"PDUIBrandTableViewCell" bundle:podBundle];
	[[self tableView] registerNib:brandNib forCellReuseIdentifier:kBrandCell];
	
	UINib *searchNib = [UINib nibWithNibName:@"PDUISearchTableViewCell" bundle:podBundle];
	[[self tableView] registerNib:searchNib forCellReuseIdentifier:kSearchCell];
	
	UINib *placeholderNib = [UINib nibWithNibName:@"PDUIBrandPlaceHolderTableViewCell" bundle:podBundle];
	[[self tableView] registerNib:placeholderNib forCellReuseIdentifier:kPlaceHolderCell];
	
	[self.tableView reloadData];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
	_viewModel = [[PDBrandListViewModel alloc] init];
	_viewModel.viewController = self;
	[_viewModel fetchBrands];
	
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.tableView addSubview:self.refreshControl];
	[self.refreshControl addTarget:self action:@selector(reloadBrands) forControlEvents:UIControlEventValueChanged];
	
	if (PopdeemThemeHasValueForKey(@"popdeem.nav")) {
		self.navigationController.navigationBar.translucent = NO;
		[self.navigationController.navigationBar setBarTintColor:PopdeemColor(PDThemeColorPrimaryApp)];
		[self.navigationController.navigationBar setTintColor:PopdeemColor(PDThemeColorPrimaryInverse)];
		[self.navigationController.navigationBar setTitleTextAttributes:@{
																																			NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryInverse),
																																			NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 16.0f)
																																			}];
		
		[self.navigationController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{
																																													NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryInverse),
																																													NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 16.0f)}
																																							 forState:UIControlStateNormal];
		if (PopdeemThemeHasValueForKey(@"popdeem.images.navigationBar")){
			[self.navigationController.navigationBar setBackgroundImage:PopdeemImage(@"popdeem.images.navigationBar") forBarMetrics:UIBarMetricsDefault];
		}
		
		[self setTitle:@"Brands"];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view data

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self cellHeight];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		if (searchEnabled) {
			return 45;
		}
	}
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (_viewModel.tableData.count == 0) {
		if (_isLoading) {
			return 2;
		} else {
			return 1;
		}
	}
	return _viewModel.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (_viewModel.tableData.count == 0) {
		if (_isLoading) {
			PDUIBrandPlaceHolderTableViewCell *cell = [[PDUIBrandPlaceHolderTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self cellHeight])];
			[cell setup];
			return cell;
		} else {
			UITableViewCell *noBrands = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
			[noBrands.textLabel setText:@"No Brands available. Pull down to refresh."];
			return noBrands;
		}
	}
	if (searchMode) {
		
	} else {
		PDUIBrandTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kBrandCell];
		PDBrand *b = [_viewModel.tableData objectAtIndex:indexPath.row];
		cell.brand = b;
		[cell setupForBrand:b];
		return cell;
	}
	
	return nil;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


 #pragma mark - Table view delegate
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PDUIHomeViewController *homeVC = [[PDUIHomeViewController alloc] init];
 [self.navigationController pushViewController:homeVC animated:YES];
}
 

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		if (!_searchBar) {
			_searchBar = [[UISearchBar alloc] init];
			[_searchBar setPlaceholder:@"Search by Name"];
			[_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
			[_searchBar setBackgroundColor:[UIColor whiteColor]];
			[_searchBar setSearchTextPositionAdjustment:UIOffsetZero];
			_searchBar.showsSearchResultsButton = NO;
			_searchBar.delegate = self;
		}
		if (!searchMode) {
			[_searchBar resignFirstResponder];
		}
		if (!searchEnabled) {
			return nil;
		}
		return _searchBar;
	}
	return nil;
}

- (void) searchTapped {
	PDLog(@"SearchTapped");
	searchEnabled = !searchEnabled;
	
	if (!searchEnabled) {
		searchMode = NO;
		[_searchBar setText:@""];
		[_searchBar resignFirstResponder];
	}
	[self.tableView beginUpdates];
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView endUpdates];
	if (searchEnabled) {
		[_searchBar becomeFirstResponder];
	}
}

- (float) cellHeight {
	if (_viewModel.tableData.count > 0) {
		return 250;
	} else if (_isLoading) {
		return 250;
	} else {
		return 100;
	}
}

- (void) reloadBrands {
	[_viewModel fetchBrands];
}

- (void)keyboardWillChange:(NSNotification *)notification {
	keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardRect = [self.view convertRect:keyboardRect fromView:nil]; //this is it!
	NSLog(@"%.2f",keyboardRect.size.height);
}
@end
