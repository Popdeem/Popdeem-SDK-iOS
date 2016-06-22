//
//  PDMsgCntrTblViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 29/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIMsgCntrTblViewController.h"
#import "PDUIMessageCell.h"
#import "PDUINoRewardsTableViewCell.h"
#import "PDUIMsgCntrViewModel.h"
#import "PDUISingleMessageViewController.h"
#import "PDUIMessageLogoutCell.h"
#import "PDTheme.h"
#import "PDSocialMediaManager.h"

@interface PDUIMsgCntrTblViewController ()
@property (nonatomic, strong) PDUIMsgCntrViewModel *model;
@end

@implementation PDUIMsgCntrTblViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDUIMsgCntrTblViewController" bundle:podBundle]) {
    self.model = [[PDUIMsgCntrViewModel alloc] initWithController:self];
    [self.model fetchMessages];
    return self;
  }
  return nil;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView reloadData];
  self.refreshControl = [[UIRefreshControl alloc]init];
  [self.refreshControl setTintColor:[UIColor darkGrayColor]];
  [self.refreshControl setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
  [self.refreshControl addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventValueChanged];
}

- (void) viewDidAppear:(BOOL)animated {
  [self.tableView reloadData];
  [self.tableView reloadInputViews];
}

- (void) reloadAction {
  [self.model fetchMessages];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
	NSLog(@"Memory");
  // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
  case 0:
			return (_model.messages.count > 0) ? _model.messages.count : 1;
			break;
	case 1:
		return [[PDSocialMediaManager manager] isLoggedInWithFacebook] ? 1 : 0;
			break;
  default:
			return 0;
			break;
	}
}

- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
  case 0:
			if (_model.messages.count > 0) {
				if ([_model.messages objectAtIndex:indexPath.row]) {
					PDUIMessageCell *cell = [[PDUIMessageCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85) message:[_model.messages objectAtIndex:indexPath.row]];
					return cell;
				} else {
					return nil;
				}
			} else if (_model.messagesLoading) {
				return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85) text:@"Fetching messages..."];
			} else {
				return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85) text:@"You have no messages."];
			}
			break;
		case 1:
			return [[PDUIMessageLogoutCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
			break;
  default:
			return nil;
			break;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
	[footerView setBackgroundColor:PopdeemColor(@"popdeem.colors.tableViewSeperatorColor")];
	return footerView;
}

 #pragma mark - Table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
  case 0:
		return 85;
		break;
		case 1:
		return 50;
		break;
  default:
		return 85;
		break;
	}
}

 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([_model.messages objectAtIndex:indexPath.row]) {
    PDUISingleMessageViewController *svc = [[PDUISingleMessageViewController alloc] initFromNib];
    [svc setMessage:_model.messages[indexPath.row]];
    [self.navigationController pushViewController:svc animated:YES];
  }
}

@end
