//
//  PDHomeViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIHomeViewController.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDUIModalLoadingView.h"
#import "PDAPIClient.h"
#import "PDUILazyLoader.h"
#import "PDUIRewardTableViewCell.h"
#import "PDUINoRewardsTableViewCell.h"
#import "PDUIPhotoCell.h"
#import "PDUICheckinCell.h"
#import "PDUIClaimViewController.h"
#import "PDUIWalletTableViewCell.h"
#import "PDUIHomeViewModel.h"
#import "PDSocialMediaManager.h"
#import "PDUISocialLoginViewController.h"
#import "PDUIFeedImageViewController.h"
#import "PDRewardActionAPIService.h"
#import "PDUIRedeemViewController.h"
#import "PDLocationValidator.h"
#import "PDConstants.h"

@interface PDUIHomeViewController () {
  BOOL rewardsLoading, feedLoading, walletLoading;
  NSIndexPath *walletSelectedIndex;
  PDReward *selectedWalletReward;
  BOOL claimAction;
}
@property (nonatomic, strong) PDUIHomeViewModel *model;
@property (nonatomic) PDUIClaimViewController *claimVC;
@property (nonatomic) BOOL *loggingIn;
@property (nonatomic, strong) PDLocationValidator *locationValidator;
@end

@implementation PDUIHomeViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDUIHomeViewController" bundle:podBundle]) {
    self.model = [[PDUIHomeViewModel alloc] initWithController:self];
    self.claimVC = [[PDUIClaimViewController alloc] initFromNib];
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
  self.model = [[PDUIHomeViewModel alloc] initWithController:self];
//  self.claimVC = [[PDClaimViewController alloc] initFromNib];
}

- (void)renderView {
  self.loadingView = [[PDUIModalLoadingView alloc] initWithDefaultsForView:self.view];
	[self.model setupView];
}

- (void)viewDidLoad {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:@"PopdeemUserLoggedInNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedItemDidDownload) name:@"PDFeedItemImageDidDownload" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedOut) name:PDUserDidLogout object:nil];
  
  [super viewDidLoad];
  [self.tableView setUserInteractionEnabled:YES];
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
  
  if (PopdeemThemeHasValueForKey(@"popdeem.nav")) {
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
    [self.navigationController.navigationBar setTintColor:PopdeemColor(@"popdeem.colors.primaryInverseColor")];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryInverseColor"),
                                                                      NSFontAttributeName : PopdeemFont(@"popdeem.fonts.primaryFont", 16.0f)}];
    
    [self.navigationController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryInverseColor"), NSFontAttributeName : PopdeemFont(@"popdeem.fonts.primaryFont", 16.0f)} forState:UIControlStateNormal];
    
    [[UINavigationBar appearance] setBarTintColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
    [[UINavigationBar appearance] setTintColor:PopdeemColor(@"popdeem.colors.primaryInverseColor")];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryInverseColor"),
                                                           NSFontAttributeName : PopdeemFont(@"popdeem.fonts.primaryFont", 16.0f)}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryInverseColor"),
                                                           NSFontAttributeName : PopdeemFont(@"popdeem.fonts.primaryFont", 16.0f)} forState:UIControlStateNormal];
  }
  
  if (PopdeemThemeHasValueForKey(@"popdeem.images.tableViewBackgroundImage")) {
    UIImageView *tvbg = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    [tvbg setImage:PopdeemImage(@"popdeem.images.tableViewBackgroundImage")];
    [self.tableView setBackgroundView:tvbg];
  }
  
  self.refreshControl = [[UIRefreshControl alloc]init];
  [self.refreshControl setTintColor:[UIColor darkGrayColor]];
  [self.refreshControl setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
  [self.refreshControl addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventValueChanged];
  self.refreshControl.layer.zPosition = self.tableView.backgroundView.layer.zPosition + 1;
  
  self.title = translationForKey(@"popdeem.home.title", @"Rewards");
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  [self.view setBackgroundColor:PopdeemColor(@"popdeem.colors.viewBackgroundColor")];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self.model fetchRewards];
		[self.model fetchFeed];
		[self.model fetchWallet];
	});
  [self renderView];
}

- (void) inboxAction {
  PDUIMsgCntrTblViewController *mvc = [[PDUIMsgCntrTblViewController alloc] initFromNib];
  [self.navigationController pushViewController:mvc animated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
  [self.view setUserInteractionEnabled:YES];
  if (_loadingView && !_loggingIn) {
    [_loadingView hideAnimated:YES];
  }
  if (_didClaim) {
    claimAction = NO;
    _didClaim = NO;
    [_model fetchWallet];
    [_segmentedControl setSelectedSegmentIndex:2];
    _model.rewards = [PDRewardStore allRewards];
    [self.tableView reloadData];
    [self.tableView reloadInputViews];
  }
}

- (void) reloadAction {
  [self.tableView setUserInteractionEnabled:NO];
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
//  [_model viewWillLayoutSubviews];
}

- (void) viewWillDisappear:(BOOL)animated {
  if (_loadingView && !_loggingIn) {
    [_loadingView hideAnimated:YES];
  }
}

- (void) viewDidDisappear:(BOOL)animated {
}

- (void) segmentedControlDidChangeValue:(PDUISegmentedControl*)sender {
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
  [footerView setBackgroundColor:PopdeemColor(@"popdeem.colors.tableViewSeperatorColor")];
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
          return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) text:translationForKey(@"popdeem.home.infoCell.noRewards", @"There are no Rewards available right now. Please check back later.")];
        } else {
          return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) text:translationForKey(@"popdeem.home.infoCell.loadingRewards", @"Please wait, we are loading your rewards")];
        }
      } else {
        reward = [_model.rewards objectAtIndex:indexPath.row];
        return [[PDUIRewardTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) reward:reward];
      }
      break;
    case 1:
      //Feeds
      if (_model.feed.count == 0) {
        if (!_model.feedLoading) {
          return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:translationForKey(@"popdeem.home.infoCell.noFeed", @"There is nothing in the Feed right now. Please check back later.")];
        } else {
          return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:translationForKey(@"popdeem.home.infoCell.loadingFeed", @"Please wait, we are loading the Feed.")];
        }
      } else {
        if (feedLoading) {
          return nil;
        }
        if (indexPath.row >= _model.feed.count) {
          return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) text:translationForKey(@"popdeem.home.infoCell.loadingFeed", @"Please wait, we are loading the Feed.")];
        }
        feedItem = [_model.feed objectAtIndex:indexPath.row];
        if (feedItem.actionImage) {
          return [[PDUIPhotoCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 165) forFeedItem:feedItem];
        } else {
          return [[PDUICheckinCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85) forFeedItem:feedItem];
        }
      }
      break;
    case 2:
      if (_model.wallet.count == 0) {
        if (!_model.walletLoading) {
          return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85) text:translationForKey(@"popdeem.home.infoCell.noWallet", @"There is nothing in your Wallet right now. Please check back later.")];
        } else {
          return [[PDUINoRewardsTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85) text:translationForKey(@"popdeem.home.infoCell.loadingWallet", @"Please wait. We are loading your Wallet.")];
        }
      } else {
        return [[PDUIWalletTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85) reward:[_model.wallet objectAtIndex:indexPath.row] parent:self];
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
      return 100;
      break;
    case 1:
      //Feed
      if (_model.feed.count == 0) {
        return 75;
      }
      if ([(PDFeedItem*)[_model.feed objectAtIndex:index] actionImage] != nil) {
        return 175;
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
      return 85;
      break;
    default:
      break;
  }
  return 0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  PDUIWalletTableViewCell *wcell;
  PDUIWalletTableViewCell *lastCell;
  PDReward *walletReward;
  __block UIAlertView *av;
  switch (_segmentedControl.selectedSegmentIndex) {
    case 0:
      //Rewards
      if (_model.rewards.count == 0) return;
      if ([_model.rewards objectAtIndex:indexPath.row]) {
        if (![[PDSocialMediaManager manager] isLoggedInWithFacebook]) {
					_loggingIn = YES;
          _loadingView = [[PDUIModalLoadingView alloc] initForView:self.navigationController.view titleText:@"Logging in" descriptionText:@"Please Wait"];
          [_loadingView showAnimated:YES];
          [[PDSocialMediaManager manager] loginWithFacebookReadPermissions:@[@"public_profile", @"email", @"user_birthday", @"user_posts", @"user_friends", @"user_education_history"] registerWithPopdeem:YES success:^{
						[[PDUser sharedInstance] refreshFacebookFriendsCallback:^(BOOL response){
						}];
            [self.model fetchRewards];
            [self.model fetchWallet];
						_loggingIn = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
              [self processClaimForIndexPath:indexPath];
            });
          } failure:^(NSError *err) {
            if ([err.domain isEqualToString:@"Popdeem.Facebook.Cancelled"]) {
							_loggingIn = NO;
              av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.facebookLoginCancelledTitle",@"Login Cancelled.")
                                              message:translationForKey(@"popdeem.common.facebookLoginCancelledBody",@"You must log in with Facebook to avail of social rewards.")
                                             delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles: nil];
              [av show];
            }
          }];
          return;
        }
        _loadingView = [[PDUIModalLoadingView alloc] initForView:self.navigationController.view titleText:@"Loading" descriptionText:@"We are preparing your reward"];
        [_loadingView showAnimated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
          [self processClaimForIndexPath:indexPath];
        });
      }
      break;
    case 1:
      //Feed
      if (_model.feed.count == 0) return;
      if ([(PDFeedItem*)_model.feed[indexPath.row] actionImage]) {
        [self.view setUserInteractionEnabled:NO];
        PDUIFeedImageViewController *ivc = [[PDUIFeedImageViewController alloc] init];
        ivc.item = _model.feed[indexPath.row];
        [[self navigationController] pushViewController:ivc animated:YES];
      }
      break;
    case 2:
      if (_model.wallet.count == 0) return;
      selectedWalletReward = [_model.wallet objectAtIndex:indexPath.row];
      if (selectedWalletReward) {
        if (selectedWalletReward.revoked) {
          UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Reward Revoked" message:@"This reward has been revoked" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
          [av show];
          return;
        }
        //For sweepstakes we dont show the alert
        if (selectedWalletReward.type == PDRewardTypeSweepstake || selectedWalletReward.type == PDRewardTypeCredit) {
          return;
        }
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Redeem Reward"
                                                     message:@"You are about to Redeem this Reward. Are you sure?"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Redeem", nil];
        [av setTag:400];
        [av show];
        
      }
//      wcell = (PDUIWalletTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
//      [wcell setSelectionStyle:UITableViewCellSelectionStyleNone];
//      if (walletSelectedIndex && [walletSelectedIndex isEqual:indexPath]) {
//        lastCell = (PDUIWalletTableViewCell*)[self.tableView cellForRowAtIndexPath:walletSelectedIndex];
//        [lastCell rotateArrowRight];
//        walletSelectedIndex = nil;
//        [wcell rotateArrowRight];
//      } else {
//        if (walletSelectedIndex) {
//          //Rotate the previous cell back to right
//          PDUIWalletTableViewCell *lastCell = (PDUIWalletTableViewCell*)[self.tableView cellForRowAtIndexPath:walletSelectedIndex];
//          [lastCell rotateArrowRight];
//        }
//        if (walletReward.type == PDRewardTypeCredit) {
//          walletSelectedIndex = nil;
//        } else {
//          walletSelectedIndex = indexPath;
//          [wcell rotateArrowDown];
//        }
//      }
//      [self.tableView beginUpdates];
//      [self.tableView endUpdates];
//      [self performSelector:@selector(scrollToIndexPath:) withObject:indexPath afterDelay:0.5];
      break;
    default:
      break;
  }
  [tableView beginUpdates];
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  //if you are doing any animation you have deselect the row here inside.
  [tableView endUpdates];
}

- (void) redeemSelectedReward {
  walletSelectedIndex = [self.tableView indexPathForSelectedRow];
  if (!selectedWalletReward) {
    return;
  }
  if (selectedWalletReward.type != PDRewardTypeSweepstake) {
    PDRewardActionAPIService *service = [[PDRewardActionAPIService alloc] init];
    _loadingView = [[PDUIModalLoadingView alloc] initForView:self.navigationController.view titleText:@"Please Wait" descriptionText:@"Redeeming your Reward"];
    [_loadingView showAnimated:YES];
    
    [service redeemReward:selectedWalletReward.identifier completion:^(NSError *error){
      [_loadingView hideAnimated:YES];
      if (error) {
        NSLog(@"Something went wrong: %@",error);
      } else {
        
        PDUIRedeemViewController *rvc = [[PDUIRedeemViewController alloc] initFromNib];
        [rvc setReward:selectedWalletReward];
        [self.navigationController pushViewController:rvc animated:YES];
        [PDWallet remove:selectedWalletReward.identifier];
        selectedWalletReward = nil;
        walletSelectedIndex = nil;
        _model.wallet = [PDWallet wallet];
        [self.tableView reloadData];
      }
    }];
  }
}

- (void) processClaimForIndexPath:(NSIndexPath*)indexPath {
  PDReward *reward = [_model.rewards objectAtIndex:indexPath.row];
  if (reward.action == PDRewardActionSocialLogin) {
    return;
  } else if (reward.action == PDRewardActionNone) {
		[_loadingView hideAnimated:YES];
		_locationValidator = [[PDLocationValidator alloc] init];
		[_locationValidator validateLocationForReward:reward completion:^(BOOL validated, PDLocation *closestLocation){
			if (validated) {
				[self.model claimNoAction:reward closestLocation:closestLocation];
			} else {
				UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Not at Location" message:translationForKey(@"popdeem.claim.verifyLocationFailed", @"You must be at this location to claim this reward. Please try later.") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[av show];
			}
		}];
  } else {
      PDUIClaimViewController *claimController = [[PDUIClaimViewController alloc] initWithMediaTypes:reward.socialMediaTypes andReward:reward location:_closestLocation];
    [claimController setHomeController:self];
    [[self navigationController] pushViewController:claimController animated:YES];
  }
}

- (void) scrollToIndexPath:(NSIndexPath*)path {
  [self.tableView scrollRectToVisible:[self.tableView rectForRowAtIndexPath:path] animated:YES];
}

- (void) redeemButtonPressed {
  selectedWalletReward = [_model.wallet objectAtIndex:walletSelectedIndex.row];
  if (selectedWalletReward.revoked) {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Reward Revoked" message:@"This reward has been revoked" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [av show];
    return;
  }
  //For sweepstakes we dont show the alert
  if (selectedWalletReward.type == PDRewardTypeSweepstake) {
    return;
  }
  
  walletSelectedIndex = [self.tableView indexPathForSelectedRow];
  
  if (selectedWalletReward.type != PDRewardTypeSweepstake) {
    PDRewardActionAPIService *service = [[PDRewardActionAPIService alloc] init];
    _loadingView = [[PDUIModalLoadingView alloc] initForView:self.navigationController.view titleText:@"Please Wait" descriptionText:@"Redeeming your Reward"];
    [_loadingView showAnimated:YES];
    
    [service redeemReward:selectedWalletReward.identifier completion:^(NSError *error){
      [_loadingView hideAnimated:YES];
      if (error) {
        NSLog(@"Something went wrong: %@",error);
      } else {
        
        PDUIRedeemViewController *rvc = [[PDUIRedeemViewController alloc] initFromNib];
        [rvc setReward:selectedWalletReward];
        [self.navigationController pushViewController:rvc animated:YES];
        [PDWallet remove:selectedWalletReward.identifier];
        selectedWalletReward = nil;
        walletSelectedIndex = nil;
        _model.wallet = [PDWallet wallet];
        [self.tableView reloadData];
      }
    }];
  }
}

- (void) messagesTapped {
  if (!_messageCenter) {
    _messageCenter = [[PDUIMsgCntrTblViewController alloc] initFromNib];
  }
  [self.navigationController pushViewController:_messageCenter animated:YES];
}

- (void) userDidLogin {
  [self.model fetchRewards];
  [self.model fetchFeed];
  [self.model fetchWallet];
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 400) {
    switch (buttonIndex) {
      case 0:
        NSLog(@"Cancel Redeem");
        walletSelectedIndex = nil;
        selectedWalletReward = nil;
        break;
      case 1:
        NSLog(@"Redeem");
        [self redeemSelectedReward];
        break;
      default:
        break;
    }
	} else if (alertView.tag == 2) {
		[_model fetchWallet];
		[_segmentedControl setSelectedSegmentIndex:2];
		_model.rewards = [PDRewardStore allRewards];
		[self.tableView reloadData];
		[self.tableView reloadInputViews];

	}
}

- (void) feedItemDidDownload {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.tableView reloadData];
	});
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.view setNeedsLayout];
	[self.view setNeedsDisplay];
	[self.tableView.tableHeaderView setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 140)];
}

- (void) loggedOut {
	[self.model fetchRewards];
	[self.model fetchFeed];
	[self.model fetchWallet];
	[self.navigationController popViewControllerAnimated:YES];
	[self.segmentedControl setSelectedSegmentIndex:0];
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.tableView reloadData];
	});
}

@end
