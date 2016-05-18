//
//  PDRewardHomeTableViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIRewardHomeTableViewController.h"
#import "PDTheme.h"
#import "PDUIModalLoadingView.h"
#import "PDAPIClient.h"
#import "PDUILazyLoader.h"
#import "PDUIRewardTableViewCell.h"
#import "PDUINoRewardsTableViewCell.h"
#import "PDUIPhotoCell.h"
#import "PDUICheckinCell.h"
#import "PDUIClaimViewController.h"
#import "PDUIWalletTableViewCell.h"
#import "PDUISocialLoginViewController.h"
#import "PDSocialMediaManager.h"


@interface PDUIRewardHomeTableViewController () {
  BOOL rewardsLoading, feedLoading, walletLoading;
}
@property (nonatomic) UIView *tableHeaderView;
@property (nonatomic) UILabel *tableHeaderLabel;
@property (nonatomic) UIImageView *tableHeaderImageView;
@property (nonatomic, strong) NSArray *rewards;
@property (nonatomic, strong) NSArray *feed;
@property (nonatomic, strong) NSArray *wallet;
@property (nonatomic) PDUIModalLoadingView *loadingView;
@property (nonatomic) PDLocation *closestLocation;
@end

@implementation PDUIRewardHomeTableViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDUIRewardHomeTableViewController" bundle:podBundle]) {
    return self;
  }
  return nil;
}

- (void)renderView {
  self.loadingView = [[PDUIModalLoadingView alloc] initWithDefaultsForView:self.view];
  
  __weak typeof(self) weakSelf = self;
  [[PDAPIClient sharedInstance] getAllRewardsSuccess:^{
    weakSelf.rewards =  [PDRewardStore allRewards];
    [weakSelf fetchLocations];
    [PDUILazyLoader loadAllRewardCoverImagesCompletion:^(BOOL success){
      [weakSelf brandImageDidDownload];
    }];
    [weakSelf.tableView reloadData];
  } failure:^(NSError * _Nonnull error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.tableView reloadData];
    });
  }];
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"feeds.fd"];
  BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:appFile];
  
  if (fileExists) {
    NSMutableArray *data = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
    [PDFeeds initWithContentsOfArray:data];
    _feed = [[PDFeeds feed] copy];
  }
  feedLoading = YES;
  [[PDAPIClient sharedInstance] getFeedsSuccess:^{
    feedLoading = NO;
    weakSelf.feed = [PDFeeds feed];
    [PDUILazyLoader loadFeedImages];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"pd_feeds.fd"];
    [NSKeyedArchiver archiveRootObject:_feed toFile:appFile];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  } failure:^(NSError *error){
    //TODO: Handle Error
    feedLoading = NO;
  }];
  
  [[PDAPIClient sharedInstance] getRewardsInWalletSuccess:^(){
    _wallet = [[PDWallet wallet] copy];
    [PDUILazyLoader loadWalletRewardCoverImagesCompletion:^(BOOL success) {
      [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
  } failure:^(NSError *error) {
    //TODO: Handle Error
  }];

  [self setupHeader];
}

- (void) fetchLocations {
  [[PDAPIClient sharedInstance] getAllLocationsSuccess:^{
    NSArray *locations = [PDLocationStore locationsOrderedByDistanceToUser];
    _closestLocation = [locations firstObject];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView reloadData];
    });
  } failure:^(NSError *error){
    NSLog(@"Locations Fail: %@",error);
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView reloadData];
    });
  }];
}

- (void) brandImageDidDownload {
  [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = translationForKey(@"popdeem.rewards.title", @"Rewards");
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  self.viewModel = [[PDRewardHomeViewModel alloc] init];
  [self.viewModel setup];
  self.rewardTableViewController = [[PDUIRewardTableViewController alloc] init];
  self.rewardsCell = [[UITableViewCell alloc] init];
  [self.tableView setUserInteractionEnabled:YES];
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
  
  [self.view setBackgroundColor:PopdeemColor(@"popdeem.colors.viewBackgroundColor")];
  [self.tableView setBackgroundColor:PopdeemColor(@"popdeem.colors.viewBackgroundColor")];
  [self.tableView setSeparatorColor:PopdeemColor(@"popdeem.colors.tableViewSeperatorColor")];
  
  [self renderView];
}

- (void) viewWillLayoutSubviews {
  if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  
  if (!_segmentedControl) {
    _segmentedControl = [[PDUISegmentedControl alloc] initWithItems:@[@"Rewards",@"Activity",@"Wallet"]];
    _segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    _segmentedControl.clipsToBounds = YES;
    
    CALayer *topBottomBorders = [CALayer layer];
    topBottomBorders.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
    topBottomBorders.borderWidth = 0.5;
    topBottomBorders.frame = CGRectMake(-1, 0, _segmentedControl.frame.size.width+2, _segmentedControl.frame.size.height);
    [_segmentedControl.layer addSublayer:topBottomBorders];
    [_segmentedControl addTarget:self action:@selector(segmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
  }
  [self.tableView.tableHeaderView setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
  [self.tableView.tableHeaderView setBackgroundColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
  if (!_tableHeaderImageView) {
    if (PopdeemThemeHasValueForKey(@"popdeem.images.homeHeaderImage")) {
      _tableHeaderImageView = [[UIImageView alloc] initWithFrame:self.tableView.tableHeaderView.frame];
      [_tableHeaderImageView setImage:PopdeemImage(@"popdeem.images.homeHeaderImage")];
      [_tableHeaderImageView setContentMode:UIViewContentModeScaleAspectFill];
      UIView *gradientView = [[UIView alloc] initWithFrame:_tableHeaderImageView.frame];
      [gradientView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
      [self.tableView.tableHeaderView addSubview:_tableHeaderImageView];
      [self.tableView.tableHeaderView addSubview:gradientView];
    }
  }
  if (!_tableHeaderLabel) {
    _tableHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, self.tableView.tableHeaderView.frame.size.width-20, 50)];
    [_tableHeaderLabel setTextAlignment:NSTextAlignmentCenter];
    [_tableHeaderLabel setNumberOfLines:3];
    [_tableHeaderLabel setFont:[UIFont systemFontOfSize:16]];
    [_tableHeaderLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryInverseColor")];
    [_tableHeaderLabel setText:translationForKey(@"popdeem.home.header.titleText", @"Share your experience on social networks to earn more rewards.")];
    [self.tableView.tableHeaderView addSubview:_tableHeaderLabel];
  }
}

- (void) setupHeader {
  
}

- (void) segmentedControlDidChangeValue:(PDUISegmentedControl*)sender {
  [self.tableView reloadData];
  [self.tableView reloadInputViews];
//  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
      if (_rewards.count == 0) return 1;
      return _rewards.count;
      break;
    case 1:
      return _feed.count;
      break;
    case 2:
      return _wallet.count;
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
      if (_rewards.count == 0) {
        if (!rewardsLoading) {
          return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:@"There are no Rewards available right now. Please check back later."];
        } else {
          return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:@"Fetching your Rewards."];
        }
      } else {
        reward = [_rewards objectAtIndex:indexPath.row];
        return [[PDUIRewardTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80) reward:reward];
      }
      break;
    case 1:
      //Feeds
      if (_feed.count == 0) {
        if (!feedLoading) {
          return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:@"There is no Feed available right now. Please check back later."];
        } else {
          return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:@"Fetching the Feed."];
        }
      } else {
        feedItem = [_feed objectAtIndex:indexPath.row];
        if (feedItem.actionImage) {
          return [[PDUIPhotoCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 165) forFeedItem:feedItem];
        } else {
          return [[PDUICheckinCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85) forFeedItem:feedItem];
        }
      }
      break;
    case 2:
      if (_wallet.count == 0) {
        if (!walletLoading) {
          return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:@"You have no items in your Wallet right now."];
        } else {
          return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:@"Fetching your Wallet."];
        }
      } else {
        if (indexPath.row == _wallet.count) {
//          static NSString *footerIdentifier = @"footerCell";
//          WalletFooterTableViewCell *cell = (WalletFooterTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:footerIdentifier];
//          if (cell == nil) {
//            cell = [[WalletFooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:footerIdentifier];
//          }
//          return cell;
        }
        return [[PDUIWalletTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) reward:[_wallet objectAtIndex:indexPath.row] parent:self];
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
      if ([(PDFeedItem*)[_feed objectAtIndex:index] actionImage] != nil) {
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
      if ([self.rewards objectAtIndex:indexPath.row]) {
        if(![[PDSocialMediaManager manager] isLoggedIn]){
          PDUISocialLoginViewController *vc = [[PDUISocialLoginViewController alloc] initWithLocationServices:YES];
          vc.delegate = self;
          [self presentViewController:vc animated:YES completion:^{
            
          }];
        } else{
          PDReward *reward = [self.rewards objectAtIndex:indexPath.row];
          PDUIClaimViewController *claimController = [[PDUIClaimViewController alloc] initWithMediaTypes:@[@(FacebookOnly)] andReward:reward location:_closestLocation];
          [[self navigationController] pushViewController:claimController animated:YES];
        }
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
