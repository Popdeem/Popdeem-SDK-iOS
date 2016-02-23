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
#import "PDSocialMediaManager.h"
#import "PDSocialLoginViewController.h"
#import "FeedImageViewController.h"

@interface PDHomeViewController () {
  BOOL rewardsLoading, feedLoading, walletLoading;
  NSIndexPath *walletSelectedIndex;
}
@property (nonatomic, strong) PDHomeViewModel *model;
@property (nonatomic) PDModalLoadingView *loadingView;
@property (nonatomic) PDLocation *closestLocation;
@property (nonatomic) PDClaimViewController *claimVC;
@end

@implementation PDHomeViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDHomeViewController" bundle:podBundle]) {
    self.model = [[PDHomeViewModel alloc] initWithController:self];
    return self;
  }
  return nil;
}

- (instancetype) init {
  if (self = [self initFromNib]) {
    return self;
  }
  return nil;
}

- (void) awakeFromNib {
  self.model = [[PDHomeViewModel alloc] initWithController:self];
}

- (void)renderView {
  self.loadingView = [[PDModalLoadingView alloc] initWithDefaultsForView:self.view];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView setUserInteractionEnabled:YES];
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 110)];
  self.refreshControl = [[UIRefreshControl alloc]init];
  [self.refreshControl setTintColor:[UIColor darkGrayColor]];
  [self.refreshControl setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
  [self.refreshControl addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventValueChanged];
  
  UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:translationForKey(@"popdeem.nav.inbox", @"Inbox") style:UIBarButtonItemStylePlain target:self action:@selector(inboxAction)];
  self.navigationItem.rightBarButtonItem = anotherButton;
  self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
  
  self.title = translationForKey(@"popdeem.home.title", @"Social Rewards");
  [[UINavigationBar appearance] setBarTintColor:PopdeemColor(@"popdeem.nav.backgroundColor")];
  [[UINavigationBar appearance] setTintColor:PopdeemColor(@"popdeem.nav.buttonTextColor")];
  
  [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : PopdeemColor(@"popdeem.nav.textColor"), NSFontAttributeName : [UIFont fontWithName:PopdeemFontName(@"popdeem.nav.fontName") size:16]}];
  [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : PopdeemColor(@"popdeem.nav.buttonTextColor"), NSFontAttributeName : [UIFont fontWithName:PopdeemFontName(@"popdeem.nav.fontName") size:16]} forState:UIControlStateNormal];
  
  //[_tableHeaderLabel setFont:[UIFont fontWithName:PopdeemFontName(@"popdeem.home.header.fontName") size:16]];
  
  [self.model fetchRewards];
  [self.model fetchFeed];
  [self.model fetchWallet];
  [self renderView];
}

- (void) inboxAction {
  PDMsgCntrTblViewController *mvc = [[PDMsgCntrTblViewController alloc] initFromNib];
  [self.navigationController pushViewController:mvc animated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
  [self.view setUserInteractionEnabled:YES];
}

- (void) reloadAction {
  switch (_segmentedControl.selectedSegmentIndex) {
    case 0:
      [self.model fetchRewards];
      break;
    case 1:
      [_model fetchFeed];
      break;
    case 2:
      [_model fetchWallet];
      break;
    default:
      break;
  }
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
  UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1.0f)];
  [footerView setBackgroundColor:PopdeemColor(@"popdeem.home.tableView.seperatorColor")];
  return footerView;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  return (section == 0) ? _segmentedControl : nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return (section == 0) ? 40 : 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.5f;
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
      if (_model.feed.count == 0) {
        return 75;
      }
      if ([(PDFeedItem*)[_model.feed objectAtIndex:index] actionImage] != nil) {
        return 120;
      } else {
        return 75;
      }
      break;
    case 2:
      //Wallet
      if (walletSelectedIndex && index == walletSelectedIndex.row) {
        if (index < _model.wallet.count) {
          PDReward *r = _model.wallet[index];
          switch (r.type) {
            case PDRewardTypeInstant:
            case PDRewardTypeCoupon:
              return 255;
              break;
            case PDRewardTypeSweepstake:
              return 185;
              break;
            default:
              break;
          }
        }
        return 255;
      }
      return 65;
      break;
    default:
      break;
  }
  return 0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  WalletTableViewCell *wcell;
  WalletTableViewCell *lastCell;
  switch (_segmentedControl.selectedSegmentIndex) {
    case 0:
      //Rewards
      if (_model.rewards.count == 0) return;
      if ([_model.rewards objectAtIndex:indexPath.row]) {
        if(![[PDSocialMediaManager manager] isLoggedIn]){
          PDSocialLoginViewController *vc = [[PDSocialLoginViewController alloc] initWithLocationServices:YES];
          vc.delegate = self;
          [self presentViewController:vc animated:YES completion:^{
            [_model fetchRewards];
          }];
        } else{
//          dispatch_async(dispatch_get_main_queue(), ^{
            PDReward *reward = [_model.rewards objectAtIndex:indexPath.row];
            PDClaimViewController *claimController = [[PDClaimViewController alloc] initWithMediaTypes:reward.socialMediaTypes andReward:reward location:_closestLocation];
            [[self navigationController] pushViewController:claimController animated:YES];
//          });
        }
      }
      break;
    case 1:
      //Feed
      if (_model.feed.count == 0) return;
      if ([(PDFeedItem*)_model.feed[indexPath.row] actionImage]) {
        [self.view setUserInteractionEnabled:NO];
        FeedImageViewController *ivc = [[FeedImageViewController alloc] init];
        ivc.item = _model.feed[indexPath.row];
        [[self navigationController] pushViewController:ivc animated:YES];
      }
      break;
    case 2:
      if (_model.wallet.count == 0) return;
      wcell = (WalletTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
      [wcell setSelectionStyle:UITableViewCellSelectionStyleNone];
      if (_model.wallet.count > 7 && indexPath.row > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
      }
      
      if (walletSelectedIndex && [walletSelectedIndex isEqual:indexPath]) {
        lastCell = (WalletTableViewCell*)[self.tableView cellForRowAtIndexPath:walletSelectedIndex];
        [lastCell rotateArrowRight];
        walletSelectedIndex = nil;
        [wcell rotateArrowRight];
      } else {
        if (walletSelectedIndex) {
          //Rotate the previous cell back to right
          WalletTableViewCell *lastCell = (WalletTableViewCell*)[self.tableView cellForRowAtIndexPath:walletSelectedIndex];
          [lastCell rotateArrowRight];
        }
        walletSelectedIndex = indexPath;
        [wcell rotateArrowDown];
      }
      [self.tableView beginUpdates];
      [self.tableView endUpdates];
      break;
    default:
      break;
  }
}

- (void) messagesTapped {
  if (!_messageCenter) {
    _messageCenter = [[PDMsgCntrTblViewController alloc] initFromNib];
  }
  [self.navigationController pushViewController:_messageCenter animated:YES];
}

@end
