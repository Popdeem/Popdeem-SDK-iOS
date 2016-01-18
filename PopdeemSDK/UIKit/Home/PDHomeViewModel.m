//
//  PDHomeViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDHomeViewModel.h"
#import "PDAPIClient.h"
#import "LazyLoader.h"
#import "PDTheme.h"

@implementation PDHomeViewModel

- (instancetype) init {
  if (self = [super init]) {
    return self;
  }
  return nil;
}

- (instancetype) initWithController:(PDHomeViewController*)controller {
  if (self = [super init]){
    self.controller = controller;
    [self setup];
    return self;
  }
  return nil;
}

- (void) setup {
  //Set up colors etc
  _controller.title = translationForKey(@"popdeem.rewards.title", @"Rewards");
  [_controller.navigationController setNavigationBarHidden:NO animated:YES];
  [_controller.view setBackgroundColor:PopdeemColor(@"popdeem.home.tableView.backgroundColor")];
  [_controller.tableView setBackgroundColor:PopdeemColor(@"popdeem.home.tableView.backgroundColor")];
  [_controller.tableView setSeparatorColor:PopdeemColor(@"popdeem.home.tableView.seperatorColor")];
  
  if (PopdeemThemeHasValueForKey(@"popdeem.home.header.backgroundImage")){
    
  }
}

- (void) fetchRewards {
  __weak typeof(self) weakSelf = self;
  _rewardsLoading = YES;
  [[PDAPIClient sharedInstance] getAllRewardsSuccess:^{
    weakSelf.rewards =  [PDRewardStore allRewards];
    [weakSelf fetchLocations];
    [LazyLoader loadAllRewardCoverImagesCompletion:^(BOOL success){
      [weakSelf brandImageDidDownload];
    }];
    _rewardsLoading = NO;
    [weakSelf.controller.tableView reloadData];
  } failure:^(NSError * _Nonnull error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      _rewardsLoading = NO;
      [weakSelf.controller.tableView reloadData];
    });
  }];
}

- (void) brandImageDidDownload {
  [_controller.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void) fetchLocations {
  [[PDAPIClient sharedInstance] getAllLocationsSuccess:^{
    NSArray *locations = [PDLocationStore locationsOrderedByDistanceToUser];
    _closestLocation = [locations firstObject];
    dispatch_async(dispatch_get_main_queue(), ^{
      [_controller.tableView reloadData];
    });
  } failure:^(NSError *error){
    NSLog(@"Locations Fail: %@",error);
    dispatch_async(dispatch_get_main_queue(), ^{
      [_controller.tableView reloadData];
    });
  }];
}

- (void) fetchWallet {
  __weak typeof(self) weakSelf = self;
  [[PDAPIClient sharedInstance] getRewardsInWalletSuccess:^(){
    _wallet = [[PDWallet wallet] copy];
    [LazyLoader loadWalletRewardCoverImagesCompletion:^(BOOL success) {
      [weakSelf.controller.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
  } failure:^(NSError *error) {
    //TODO: Handle Error
  }];
}

- (void) fetchFeed {
  _feedLoading = YES;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"feeds.fd"];
  BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:appFile];
  if (fileExists) {
    NSMutableArray *data = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
    [PDFeeds initWithContentsOfArray:data];
    _feed = [[PDFeeds feed] copy];
  }
  
  __weak typeof(self) weakSelf = self;
  [[PDAPIClient sharedInstance] getFeedsSuccess:^{
    _feedLoading = NO;
    weakSelf.feed = [PDFeeds feed];
    [LazyLoader loadFeedImages];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"pd_feeds.fd"];
    [NSKeyedArchiver archiveRootObject:_feed toFile:appFile];
    [self.controller.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  } failure:^(NSError *error){
    //TODO: Handle Error
    _feedLoading = NO;
  }];
}

- (void) viewWillLayoutSubviews {
  if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
    _controller.edgesForExtendedLayout = UIRectEdgeNone;
  }
  
  if (!_controller.segmentedControl) {
    _controller.segmentedControl = [[PDSegmentedControl alloc] initWithItems:@[@"Rewards",@"Activity",@"Wallet"]];
    _controller.segmentedControl.frame = CGRectMake(0, 0, _controller.view.frame.size.width, 40);
    _controller.segmentedControl.clipsToBounds = YES;
    
    CALayer *topBottomBorders = [CALayer layer];
    topBottomBorders.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
    topBottomBorders.borderWidth = 0.5;
    topBottomBorders.frame = CGRectMake(-1, 0, _controller.segmentedControl.frame.size.width+2, _controller.segmentedControl.frame.size.height);
    [_controller.segmentedControl.layer addSublayer:topBottomBorders];
    [_controller.segmentedControl addTarget:_controller action:@selector(segmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
  }
  [_controller.tableView.tableHeaderView setFrame:CGRectMake(0, 0, _controller.tableView.frame.size.width, 100)];
  [_controller.tableView.tableHeaderView setBackgroundColor:PopdeemColor(@"popdeem.home.header.backgroundColor")];
  
  if (!_tableHeaderImageView) {
    if (PopdeemThemeHasValueForKey(@"popdeem.home.tableView.header.backgroundImage")) {
      _tableHeaderImageView = [[UIImageView alloc] initWithFrame:_controller.tableView.tableHeaderView.frame];
      [_tableHeaderImageView setImage:PopdeemImage(@"popdeem.home.tableView.header.backgroundImage")];
      [_tableHeaderImageView setContentMode:UIViewContentModeScaleAspectFill];
      UIView *gradientView = [[UIView alloc] initWithFrame:_tableHeaderImageView.frame];
      [gradientView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
      [_controller.tableView.tableHeaderView addSubview:_tableHeaderImageView];
      [_controller.tableView.tableHeaderView addSubview:gradientView];
    }
  }
  if (!_tableHeaderLabel) {
    _tableHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, _controller.tableView.tableHeaderView.frame.size.width-20, 50)];
    [_tableHeaderLabel setTextAlignment:NSTextAlignmentCenter];
    [_tableHeaderLabel setNumberOfLines:3];
    [_tableHeaderLabel setFont:[UIFont systemFontOfSize:16]];
    [_tableHeaderLabel setTextColor:PopdeemColor(@"popdeem.home.tableView.header.textColor")];
    [_tableHeaderLabel setText:translationForKey(@"popdeem.home.header.titleText", @"Share your experience on nocial networks to earn more rewards.")];
    [_controller.tableView.tableHeaderView addSubview:_tableHeaderLabel];
  }

}

@end
