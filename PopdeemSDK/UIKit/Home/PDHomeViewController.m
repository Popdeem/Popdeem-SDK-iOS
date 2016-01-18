//
//  PDHomeViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDHomeViewController.h"
#import "PDTheme.h"
#import "PDModalLoadingView.h"
#import "PDAPIClient.h"
#import "LazyLoader.h"
#import "RewardTableViewCell.h"
#import "NoRewardsTableViewCell.h"
#import "PhotoCell.h"
#import "CheckinCell.h"
#import "PDClaimViewController.h"
#import "WalletTableViewCell.h"
#import "PDHomeViewModel.h"


@interface PDHomeViewController () {
  BOOL rewardsLoading, feedLoading, walletLoading;
}
@property (nonatomic) PDHomeViewModel *model;
@property (nonatomic) PDModalLoadingView *loadingView;
@property (nonatomic) PDLocation *closestLocation;
@end

@implementation PDHomeViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDRewardHomeTableViewController" bundle:podBundle]) {
    self.model = [[PDHomeViewModel alloc] initWithController:self];
    return self;
  }
  return nil;
}

- (void)renderView {
  self.loadingView = [[PDModalLoadingView alloc] initWithDefaultsForView:self.view];
  [_model fetchRewards];
  [_model fetchFeed];
  [_model fetchWallet];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView setUserInteractionEnabled:YES];
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
  [self renderView];
}

- (void) viewWillLayoutSubviews {
  [_model viewWillLayoutSubviews];
}

- (void) segmentedControlDidChangeValue:(PDSegmentedControl*)sender {
  [self.tableView reloadData];
  [self.tableView reloadInputViews];
  [self.tableView reloadSectionIndexTitles];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  return [[UIView alloc] init];
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return _segmentedControl;
  }
  return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return 40;
  }
  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (_segmentedControl.selectedSegmentIndex) {
    case 0:
      return _model.rewards.count > 0 ? _model.rewards.count : 1;
      break;
    case 1:
      return _model.feed.count > 0 ? _model.feed.count : 1;
      break;
    case 2:
      return _model.wallet.count > 0 ? _model.wallet.count : 1;
      break;
      default:
      return 1;
  }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PDReward *reward;
  PDFeedItem *feedItem;
  switch (_segmentedControl.selectedSegmentIndex) {
    case 0:
      //Rewards
      if (_model.rewards.count == 0) {
        if (!_model.rewardsLoading) {
          return [[NoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:@"There are no Rewards available right now. Please check back later."];
        } else {
          return [[NoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:@"Fetching your Rewards."];
        }
      } else {
        reward = [_model.rewards objectAtIndex:indexPath.row];
        return [[RewardTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80) reward:reward];
      }
      break;
    case 1:
      //Feeds
      if (_model.feed.count == 0) {
        if (!_model.feedLoading) {
          return [[NoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:@"There is no Feed available right now. Please check back later."];
        } else {
          return [[NoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:@"Fetching the Feed."];
        }
      } else {
        feedItem = [_model.feed objectAtIndex:indexPath.row];
        if (feedItem.actionImage) {
          return [[PhotoCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 165) forFeedItem:feedItem];
        } else {
          return [[CheckinCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85) forFeedItem:feedItem];
        }
      }
      break;
    case 2:
      if (_model.wallet.count == 0) {
        if (!_model.walletLoading) {
          return [[NoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:@"You have no items in your Wallet right now."];
        } else {
          return [[NoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:@"Fetching your Wallet."];
        }
      } else {
        if (indexPath.row == _model.wallet.count) {
//          static NSString *footerIdentifier = @"footerCell";
//          WalletFooterTableViewCell *cell = (WalletFooterTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:footerIdentifier];
//          if (cell == nil) {
//            cell = [[WalletFooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:footerIdentifier];
//          }
//          return cell;
        }
        return [[WalletTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) reward:[_model.wallet objectAtIndex:indexPath.row] parent:self];
      }
    default:
      break;
  }
  return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self cellHeightForIndex:indexPath.row];
}

- (float) cellHeightForIndex:(NSInteger)index {
  switch (_segmentedControl.selectedSegmentIndex) {
    case 0:
      //Rewards
      return 85;
      break;
    case 1:
      //Feed
      if ([(PDFeedItem*)[_model.feed objectAtIndex:index] actionImage] != nil) {
        return 120;
      } else {
        return 75;
      }
      break;
    case 2:
      //Wallet
      return 85;
      break;
    default:
      break;
  }
  return 0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  switch (_segmentedControl.selectedSegmentIndex) {
    case 0:
      //Rewards
      if ([_model.rewards objectAtIndex:indexPath.row]) {
        PDReward *reward = [_model.rewards objectAtIndex:indexPath.row];
        PDClaimViewController *claimController = [[PDClaimViewController alloc] initWithMediaTypes:@[@(FacebookOnly)] andReward:reward location:_closestLocation];
        [[self navigationController] pushViewController:claimController animated:YES];
      }
      break;
    case 1:
      //Feed
      break;
    case 2:
      //Wallet
      break;
    default:
      break;
  }
}

@end
