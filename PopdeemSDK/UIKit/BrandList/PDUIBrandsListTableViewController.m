//
//  PDUIBrandsListTableViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIBrandsListTableViewController.h"
#import "PopdeemSDK.h"

#define kBrandCell @"BrandCell"
#define kSearchCell @"SearchCell"
#define kPlaceHolderCell @"PlaceholderCell"

@interface PDUIBrandsListTableViewController () {
	BOOL searchMode;
	BOOL searchEnabled;
	BOOL isLoading;
}

@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) NSMutableArray *searchData;
@property (nonatomic, retain) UISearchBar *searchBar;
@end


@implementation PDUIBrandsListTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	searchEnabled = NO;
	searchMode = NO;
	isLoading = YES;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _tableData.count > 0 ? _tableData.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (_tableData.count == 0) {
		if (isLoading) {
			return [self.tableView dequeueReusableCellWithIdentifier:kPlaceHolderCell];
		} else {
			
		}
	}
	if (searchMode) {
		
	} else {
		
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

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

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
	float cellHeight = self.view.frame.size.height*0.30;
	return cellHeight;
}

@end
