//
//  PDHomeViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PopdeemSDK.h"
#import "PDUIHomeViewController.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDAPIClient.h"
#import "PDUINoRewardsTableViewCell.h"
#import "PDUIPhotoCell.h"
#import "PDUICheckinCell.h"
#import "PDUIClaimViewController.h"
#import "PDUIHomeViewModel.h"
#import "PDSocialMediaManager.h"
#import "PDUIFeedImageViewController.h"
#import "PDRewardActionAPIService.h"
#import "PDUIRedeemViewController.h"
#import "PDLocationValidator.h"
#import "PDUIRewardWithRulesTableViewCell.h"
#import "PDUIWalletRewardTableViewCell.h"
#import "PDUIInstagramUnverifiedWalletTableViewCell.h"
#import "PDUIFBLoginWithWritePermsViewController.h"
#import "PDUINoRewardTableViewCell.h"
#import "PDUISettingsViewController.h"


#define kPlaceholderCell @"PlaceholderCell"
#define kRewardWithRulesTableViewCell @"RewardWithRulesCell"
#define kWalletTableViewCell @"WalletCell"
#define kInstaUnverifiedTableViewCell @"kInstaUnverifiedTableViewCell"
#define kNoRewardsCell @"NoRewardsCell"

@interface PDUIHomeViewController () {
  BOOL rewardsLoading, feedLoading, walletLoading;
  NSIndexPath *walletSelectedIndex;
  PDReward *selectedWalletReward;
  BOOL claimAction;
	BOOL autoVerify;
	NSInteger verifyRewardId;
}
@property (nonatomic, strong) PDUIHomeViewModel *model;
@property (nonatomic) PDUIClaimViewController *claimVC;
@property (nonatomic) BOOL *loggingIn;
@property (nonatomic, strong) PDLocationValidator *locationValidator;
@end

@implementation PDUIHomeViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
  if (self = [self initWithNibName:@"PDUIHomeViewController" bundle:podBundle]) {
    self.model = [[PDUIHomeViewModel alloc] initWithController:self];
    self.claimVC = [[PDUIClaimViewController alloc] initFromNib];
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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

- (void) registerNibs {
	NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
	UINib *pcnib = [UINib nibWithNibName:@"PlaceholderTableViewCell" bundle:podBundle];
	[[self tableView] registerNib:pcnib forCellReuseIdentifier:kPlaceholderCell];
	
	UINib *rwrcnib = [UINib nibWithNibName:@"PDUIRewardWithRulesTableViewCell" bundle:podBundle];
	[[self tableView] registerNib:rwrcnib forCellReuseIdentifier:kRewardWithRulesTableViewCell];
	
	UINib *walletnib = [UINib nibWithNibName:@"PDUIWalletRewardTableViewCell" bundle:podBundle];
	[[self tableView] registerNib:walletnib forCellReuseIdentifier:kWalletTableViewCell];

	UINib *instaUnverified = [UINib nibWithNibName:@"PDUIInstagramUnverifiedWalletTableViewCell" bundle:podBundle];
	[[self tableView] registerNib:instaUnverified forCellReuseIdentifier:kInstaUnverifiedTableViewCell];
	
	UINib *noRewards = [UINib nibWithNibName:@"PDUINoRewardTableViewCell" bundle:podBundle];
	[[self tableView] registerNib:noRewards forCellReuseIdentifier:kNoRewardsCell];
	
}

- (void)viewDidLoad {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:FacebookLoginSuccess object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedItemDidDownload) name:@"PDFeedItemImageDidDownload" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedOut) name:PDUserDidLogout object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postVerified) name:InstagramVerifySuccessFromWallet object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramPostMade:) name:InstagramPostMade object:nil];
	[self registerNibs];
	
  [super viewDidLoad];
  [self.tableView setUserInteractionEnabled:YES];
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
  
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
  [self.view setBackgroundColor:PopdeemColor(PDThemeColorViewBackground)];
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
- (void) settingsAction {
	PDUISettingsViewController *mvc = [[PDUISettingsViewController alloc] initFromNib];
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
	AbraLogEvent(ABRA_EVENT_PAGE_VIEWED, @{ABRA_PROPERTYNAME_SOURCE_PAGE : ABRA_PROPERTYVALUE_PAGE_REWARDS_HOME});
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
	switch(sender.selectedSegmentIndex) {
			case 0:
			AbraLogEvent(ABRA_EVENT_PAGE_VIEWED, @{ABRA_PROPERTYNAME_SOURCE_PAGE : ABRA_PROPERTYVALUE_PAGE_REWARDS_HOME});
			break;
		case 1:
			AbraLogEvent(ABRA_EVENT_PAGE_VIEWED, @{ABRA_PROPERTYNAME_SOURCE_PAGE : ABRA_PROPERTYVALUE_PAGE_ACTIVITY_FEED});
			break;
		case 2:
			AbraLogEvent(ABRA_EVENT_PAGE_VIEWED, @{ABRA_PROPERTYNAME_SOURCE_PAGE : ABRA_PROPERTYVALUE_PAGE_WALLET});
			break;
			default:
			break;
	}
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
  [footerView setBackgroundColor:PopdeemColor(PDThemeColorTableViewSeperator)];
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
      if (_model.rewards.count == 0) {
        if (!_model.rewardsLoading) {
					PDUINoRewardTableViewCell *norw = [[self tableView] dequeueReusableCellWithIdentifier:kNoRewardsCell];
					[norw setupWithMessage:translationForKey(@"popdeem.home.infoCell.noRewards",@"There are no Rewards available right now. Please check back later.")];
					return norw;
        } else {
					return [self.tableView dequeueReusableCellWithIdentifier:kPlaceholderCell];
        }
      } else {
        reward = [_model.rewards objectAtIndex:indexPath.row];
				
				PDUIRewardWithRulesTableViewCell *rwrcell = [self.tableView dequeueReusableCellWithIdentifier:kRewardWithRulesTableViewCell];
				[rwrcell setupForReward:reward];
				return rwrcell;
				
      }
      break;
    case 1:
      //Feeds
      if (_model.feed.count == 0) {
        if (!_model.feedLoading) {
					PDUINoRewardTableViewCell *norw = [[self tableView] dequeueReusableCellWithIdentifier:kNoRewardsCell];
					[norw setupWithMessage:translationForKey(@"popdeem.home.infoCell.noFeed",@"There is nothing in the Feed right now. Please check back later.")];
					return norw;
        } else {
          return [self.tableView dequeueReusableCellWithIdentifier:kPlaceholderCell];
        }
      } else {
        if (feedLoading) {
          return nil;
        }
        if (indexPath.row >= _model.feed.count) {
          return [self.tableView dequeueReusableCellWithIdentifier:kPlaceholderCell];
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
					PDUINoRewardTableViewCell *norw = [[self tableView] dequeueReusableCellWithIdentifier:kNoRewardsCell];
					[norw setupWithMessage:translationForKey(@"popdeem.home.infoCell.noWallet",@"There is nothing in your Wallet right now. Please check back later.")];
					return norw;
        } else {
          return [self.tableView dequeueReusableCellWithIdentifier:kPlaceholderCell];
        }
      } else {
				reward = [_model.wallet objectAtIndex:indexPath.row];
				if (reward.claimedSocialNetwork == PDSocialMediaTypeInstagram && reward.instagramVerified == NO) {
					PDUIInstagramUnverifiedWalletTableViewCell *walletCell = [self.tableView dequeueReusableCellWithIdentifier:kInstaUnverifiedTableViewCell];
					[walletCell setupForReward:reward];
					if (autoVerify && verifyRewardId == reward.identifier) {
						[walletCell beginVerifying];
						autoVerify = NO;
					}
					return walletCell;
				} else {
					PDUIWalletRewardTableViewCell *walletCell = [self.tableView dequeueReusableCellWithIdentifier:kWalletTableViewCell];
					[walletCell setupForReward:reward];
					return walletCell;
				}
      }
    default:
      break;
  }
  return nil;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell isKindOfClass:[PDUIInstagramUnverifiedWalletTableViewCell class]]) {
		[(PDUIInstagramUnverifiedWalletTableViewCell*)cell wake];
	}
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (_segmentedControl.selectedSegmentIndex) {
  case 0:
			return NO;
			break;
		case 1:
			return NO;
			break;
		case 2:
			return NO;
			break;
  default:
			return NO;
			break;
	}
	return NO;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
	PDReward *r;
	r = [_model.wallet objectAtIndex:indexPath.row];
	
	if (r.instagramVerified == NO) {
		UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
																																			title:translationForKey(@"popdeem.instagram.wallet.verifyButtonTitle", @"Verify")
																																		handler:^(UITableViewRowAction *rowAction, NSIndexPath *indexPath){
																																			
																																		}];
		action.backgroundColor = PopdeemColor(PDThemeColorPrimaryApp);
		return @[action];
	}
	return @[];
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
        return 100;
      }
      if ([(PDFeedItem*)[_model.feed objectAtIndex:index] actionImage] != nil) {
        return 175;
      } else {
        return 75;
      }
      break;
    case 2:
      //Wallet
      return 100;
      break;
    default:
      break;
  }
  return 0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  PDUIWalletTableViewCell *wcell;
//  PDUIWalletTableViewCell *lastCell;
//  PDReward *walletReward;
//  __block UIAlertView *av;
  switch (_segmentedControl.selectedSegmentIndex) {
    case 0:
      //Rewards
      if (_model.rewards.count == 0) return;
      if ([_model.rewards objectAtIndex:indexPath.row]) {
        if (![[PDSocialMediaManager manager] isLoggedInWithFacebook]) {
					dispatch_async(dispatch_get_main_queue(), ^{
						PDUIFBLoginWithWritePermsViewController *fbVC = [[PDUIFBLoginWithWritePermsViewController alloc] initForParent:self.navigationController
																																																								 loginType:PDFacebookLoginTypeRead];
						if (!fbVC) {
							return;
						}
						self.definesPresentationContext = YES;
						fbVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
						fbVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
						[self presentViewController:fbVC animated:YES completion:^(void){}];
					});
          return;
        }
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
          UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Reward Revoked"
																											 message:@"This reward has been revoked"
																											delegate:self
																						 cancelButtonTitle:@"OK"
																						 otherButtonTitles: nil];
          [av show];
          return;
        }
        //For sweepstakes we dont show the alert
        if (selectedWalletReward.type == PDRewardTypeSweepstake || selectedWalletReward.type == PDRewardTypeCredit) {
					[self sweepstakeAlert];
          return;
        }
				if (selectedWalletReward.claimedSocialNetwork == PDSocialMediaTypeInstagram && selectedWalletReward.instagramVerified == NO) {
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
        PDLogError(@"Something went wrong: %@",error);
      } else {
        
        PDUIRedeemViewController *rvc = [[PDUIRedeemViewController alloc] initFromNib];
        [rvc setReward:selectedWalletReward];
        [self.navigationController pushViewController:rvc animated:YES];
        [PDWallet remove:selectedWalletReward.identifier];
        selectedWalletReward = nil;
        walletSelectedIndex = nil;
        _model.wallet = [PDWallet wallet];
        [self.tableView reloadData];
				if (selectedWalletReward) {
					AbraLogEvent(ABRA_EVENT_REDEEMED_REWARD, (@{
																											ABRA_PROPERTYNAME_REWARD_NAME : selectedWalletReward.rewardDescription,
																											ABRA_PROPERTYNAME_REWARD_ID : [NSString stringWithFormat:@
																																										 "%li",selectedWalletReward.identifier]
																											}));
				}
      }
    }];
  }
}

- (void) processClaimForIndexPath:(NSIndexPath*)indexPath {
  PDReward *reward = [_model.rewards objectAtIndex:indexPath.row];
  if (reward.action == PDRewardActionSocialLogin) {
    return;
  } else if (reward.action == PDRewardActionNone) {
		_locationValidator = [[PDLocationValidator alloc] init];
		[_locationValidator validateLocationForReward:reward completion:^(BOOL validated, PDLocation *closestLocation){
			if (validated) {
				[self.model claimNoAction:reward closestLocation:closestLocation];
			} else {
				UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Not at Location"
																										 message:translationForKey(
																																							 @"popdeem.claim.verifyLocationFailed",
																																							 @"You must be at this location to claim this reward. Please try later.")
																										delegate:self
																					 cancelButtonTitle:@"OK"
																					 otherButtonTitles:nil];
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
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Reward Revoked"
																								 message:@"This reward has been revoked"
																								delegate:self
																			 cancelButtonTitle:@"OK"
																			 otherButtonTitles: nil];
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
    _loadingView = [[PDUIModalLoadingView alloc] initForView:self.navigationController.view
																									 titleText:@"Please Wait"
																						 descriptionText:@"Redeeming your Reward"];
    [_loadingView showAnimated:YES];
    
    [service redeemReward:selectedWalletReward.identifier completion:^(NSError *error){
      [_loadingView hideAnimated:YES];
      if (error) {
        PDLogError(@"Something went wrong: %@",error);
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
	AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
																								ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_FACEBOOK,
																								ABRA_PROPERTYNAME_SOURCE_PAGE : @"Rewards Home"
																								}));
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 400) {
    switch (buttonIndex) {
      case 0:
        PDLog(@"Cancel Redeem");
        walletSelectedIndex = nil;
        selectedWalletReward = nil;
        break;
      case 1:
        PDLog(@"Redeem");
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

- (void) postVerified {
	[self.model fetchWallet];
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.instagram.postVerified.title", @"Congratulations")
																							 message:translationForKey(@"popdeem.instagram.postVerified.body", @"Your post has been successfully verified.")
																							delegate:self
																		 cancelButtonTitle:@"OK"
																		 otherButtonTitles:nil];
	[av show];
}

- (void) instagramPostMade:(NSNotification*)notification {
	autoVerify = YES;
	NSNumber *ident = [[notification userInfo] objectForKey:@"rewardId"];
	if (ident) {
		verifyRewardId = [ident integerValue];
	}
}

- (void) sweepstakeAlert {
	if (!selectedWalletReward) return;
	
	
}



@end
