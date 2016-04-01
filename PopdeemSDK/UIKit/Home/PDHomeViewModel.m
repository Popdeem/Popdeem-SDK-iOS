//
//  PDHomeViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDHomeViewModel.h"
#import "PDAPIClient.h"
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
    return self;
  }
  return nil;
}

- (void) setup {
  
  [self fetchRewards];
  [self fetchFeed];
  [self fetchWallet];
  
  //Set up colors etc
  _controller.navigationController.navigationBar.backgroundColor = PopdeemColor(@"popdeem.nav.backgroundColor");
  _controller.navigationController.navigationBar.barTintColor = PopdeemColor(@"popdeem.nav.textColor");
  
  [[[_controller navigationController] navigationBar] setBarTintColor:PopdeemColor(@"popdeem.nav.textColor")];
  [[[_controller navigationController] navigationBar] setBarTintColor:PopdeemColor(@"popdeem.nav.buttonTextColor")];
  [[[_controller navigationController] navigationBar] setTranslucent:NO];
  _controller.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:PopdeemColor(@"popdeem.nav.textColor")};
  
  _controller.title = translationForKey(@"popdeem.rewards.title", @"Rewards");
  [_controller.navigationController setNavigationBarHidden:NO animated:YES];
  [_controller.view setBackgroundColor:PopdeemColor(@"popdeem.home.tableView.backgroundColor")];
  [_controller.tableView setBackgroundColor:PopdeemColor(@"popdeem.home.tableView.backgroundColor")];
  [_controller.tableView setSeparatorColor:PopdeemColor(@"popdeem.home.tableView.seperatorColor")];
  
  UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Inbox" style:UIBarButtonItemStylePlain target:_controller action:@selector(messagesTapped)];
  self.controller.navigationItem.rightBarButtonItem = anotherButton;
}

- (void) fetchRewards {
  __weak typeof(self) weakSelf = self;
  _rewardsLoading = YES;
  [[PDAPIClient sharedInstance] getAllRewardsSuccess:^{
    weakSelf.rewards =  [PDRewardStore orderedByDistanceFromUser];
    [LazyLoader loadAllRewardCoverImagesCompletion:^(BOOL success){
      [weakSelf brandImageDidDownload];
    }];
    _rewardsLoading = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.controller.tableView reloadData];
      [weakSelf.controller.refreshControl endRefreshing];
      [weakSelf.controller.tableView setUserInteractionEnabled:YES];
    });
  } failure:^(NSError * _Nonnull error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      _rewardsLoading = NO;
      [weakSelf.controller.tableView reloadData];
      [weakSelf.controller.refreshControl endRefreshing];
      [weakSelf.controller.tableView setUserInteractionEnabled:YES];
    });
  }];
}

- (void) brandImageDidDownload {
  [_controller.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void) fetchLocations {
  __weak typeof(self) weakSelf = self;
  [[PDAPIClient sharedInstance] getAllLocationsSuccess:^{
    NSArray *locations = [PDLocationStore locationsOrderedByDistanceToUser];
    weakSelf.controller.closestLocation = [locations firstObject];
    weakSelf.closestLocation = [locations firstObject];
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.controller.tableView reloadData];
    });
  } failure:^(NSError *error){
    NSLog(@"Locations Fail: %@",error);
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.controller.tableView reloadData];
    });
  }];
}

- (void) fetchWallet {
  __weak typeof(self) weakSelf = self;
  [[PDAPIClient sharedInstance] getRewardsInWalletSuccess:^() {
    weakSelf.wallet = [[PDWallet wallet] copy];
    [weakSelf.controller.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [weakSelf.controller.refreshControl endRefreshing];
    [LazyLoader loadWalletRewardCoverImagesCompletion:^(BOOL success) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.controller.tableView reloadData];
        [weakSelf.controller.refreshControl endRefreshing];
        [weakSelf.controller.tableView setUserInteractionEnabled:YES];
      });
    }];
  } failure:^(NSError *error) {
    //TODO: Handle Error
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.controller.tableView reloadData];
      [weakSelf.controller.refreshControl endRefreshing];
      [weakSelf.controller.tableView setUserInteractionEnabled:YES];
    });
  }];
}

- (void) fetchFeed {
  _feedLoading = YES;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"pdfeeds.fd"];
  BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:appFile];
  if (fileExists) {
    NSMutableArray *data = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
    [PDFeeds initWithContentsOfArray:data];
    _feed = [[PDFeeds feed] copy];
  }
  
  __weak typeof(self) weakSelf = self;
  [[PDAPIClient sharedInstance] getFeedsSuccess:^{
    weakSelf.feedLoading = NO;
    weakSelf.feed = [PDFeeds feed];
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.controller.tableView reloadData];
      [weakSelf.controller.refreshControl endRefreshing];
      [weakSelf.controller.tableView setUserInteractionEnabled:YES];
    });
    NSLog(@"%i",weakSelf.feed.count);
    [LazyLoader loadFeedImages];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"pd_feeds.fd"];
    [NSKeyedArchiver archiveRootObject:weakSelf.feed toFile:appFile];
  } failure:^(NSError *error){
    //TODO: Handle Error
    _feedLoading = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.controller.tableView reloadData];
      [weakSelf.controller.refreshControl endRefreshing];
      [weakSelf.controller.tableView setUserInteractionEnabled:YES];
    });
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
  [_controller.tableView.tableHeaderView setFrame:CGRectMake(0, 0, _controller.tableView.frame.size.width, 110)];
  [_controller.tableView.tableHeaderView setBackgroundColor:PopdeemColor(@"popdeem.home.header.backgroundColor")];
  
  CGRect inboxButtonFrame = CGRectMake(_controller.tableView.tableHeaderView.frame.size.width-5-20, 5, 20, 20);
  _controller.inboxButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [_controller.inboxButton setFrame:inboxButtonFrame];
  _controller.inboxButton.tintColor = PopdeemColor(@"popdeem.home.inboxButton.tintColor");
  [_controller.inboxButton setImage:[UIImage imageNamed:@"pd_mail"] forState:UIControlStateNormal];
  [_controller.inboxButton addTarget:_controller action:@selector(inboxAction) forControlEvents:UIControlEventTouchUpInside];
  [_controller.tableView.tableHeaderView addSubview:_controller.inboxButton];
  
  if (!_tableHeaderImageView) {
    if (PopdeemThemeHasValueForKey(@"popdeem.home.header.backgroundImage")) {
      _tableHeaderImageView = [[UIImageView alloc] initWithFrame:_controller.tableView.tableHeaderView.frame];
      [_tableHeaderImageView setImage:PopdeemImage(@"popdeem.home.header.backgroundImage")];
      [_tableHeaderImageView setContentMode:UIViewContentModeScaleAspectFill];
      UIView *gradientView = [[UIView alloc] initWithFrame:_tableHeaderImageView.frame];
      [gradientView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
      [_controller.tableView.tableHeaderView addSubview:_tableHeaderImageView];
      [_controller.tableView.tableHeaderView addSubview:gradientView];
    }
  }
  if (!_tableHeaderLabel) {
    _tableHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 27.5, _controller.tableView.tableHeaderView.frame.size.width-20, 50)];
    [_tableHeaderLabel setTextAlignment:NSTextAlignmentCenter];
    [_tableHeaderLabel setNumberOfLines:3];
    [_tableHeaderLabel setFont:PopdeemFont(@"popdeem.home.header.fontName",16)];
    [_tableHeaderLabel setTextColor:PopdeemColor(@"popdeem.home.header.textColor")];
    [_tableHeaderLabel setText:translationForKey(@"popdeem.home.header.titleText", @"Share your experience on nocial networks to earn more rewards.")];
    [_controller.tableView.tableHeaderView addSubview:_tableHeaderLabel];
  }
}

- (void) claimNoAction:(PDReward*)reward {
  __weak typeof(reward) weakReward = reward;
  __weak typeof(self) weakSelf = self;
  if (_controller.loadingView) {
    [_controller.loadingView hideAnimated:YES];
  }
  _controller.loadingView = [[PDModalLoadingView alloc]
                             initForView:self.controller.navigationController.view
                             titleText:@"Please Wait"
                             descriptionText:@"Claiming your Reward"];
  
  [_controller.loadingView showAnimated:YES];
  [[PDAPIClient sharedInstance] claimReward:reward.identifier
                                   location:nil
                                withMessage:nil
                              taggedFriends:nil
                                      image:nil
                                   facebook:YES
                                    twitter:NO
                                    success:^(){
                                      NSLog(@"No Action Reward Was CLaimed");
                                      [PDRewardStore deleteReward:weakReward.identifier];
                                      weakSelf.rewards = [PDRewardStore allRewards];
                                      [weakSelf.controller.tableView reloadData];
                                      if (weakSelf.controller.loadingView) {
                                        [weakSelf.controller.loadingView hideAnimated:YES];
                                      }
                                      UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Reward Claimed"
                                                                                        message:@"You have claimed your reward. It will be displayed in your wallet shortly"
                                                                                       delegate:self.controller
                                                                              cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                                      [success show];
                                    } failure:^(NSError *error) {
                                      NSLog(@"An error occurred when Claiming No Action Reward;");
                                      [weakSelf.controller.loadingView hideAnimated:YES];
                                      UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                                        message:@"Something went wrong when claiming your reward. Please try again later."
                                                                                       delegate:self.controller
                                                                              cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                                      [failure show];
                                    }];
}

@end
