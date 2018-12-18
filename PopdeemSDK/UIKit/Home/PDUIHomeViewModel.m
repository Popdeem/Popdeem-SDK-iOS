//
//  PDHomeViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIHomeViewModel.h"
#import "PDAPIClient.h"
#import "PDTheme.h"
#import "PDUIInboxButton.h"
#import "PDMessageAPIService.h"
#import "UIButton+MessageButtonFactory.h"
#import "PDRFeedItem.h"
#import "PDUIGratitudeViewController.h"
#import "PDLocationStore.h"
//#import "PDUIHomeViewController.h"


@interface PDUIHomeViewModel(){
}
@end

@implementation PDUIHomeViewModel

- (instancetype) init {
  if (self = [super init]) {
    return self;
  }
  return nil;
}

- (instancetype) initWithController:(PDUIHomeViewController*)controller {
  if (self = [super init]){
    self.controller = controller;
    return self;
  }
  return nil;
}

- (void) setup {
  
  [self fetchRewards];
  //  [self fetchFeed]
  self.feed = [PDFeeds feed];
  [self fetchWallet];
  [self fetchInbox];
  
  _controller.title = translationForKey(@"popdeem.rewards.title", @"Rewards");
  [_controller.view setBackgroundColor:PopdeemColor(PDThemeColorViewBackground)];
  [_controller.tableView setBackgroundColor:PopdeemColor(PDThemeColorViewBackground)];
  [_controller.tableView setSeparatorColor:[UIColor clearColor]];
  _controller.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
}

- (void) fetchRewards {
  _rewardsLoading = YES;
  if (_brand) {
    [self fetchRewardsForBrand];
  } else {
    [self fetchAllRewards];
  }
}

- (void) fetchRewardsForBrand {
  __weak typeof(self) weakSelf = self;
  [[PDAPIClient sharedInstance] getRewardsForBrandId:_brand.identifier success:^{
    weakSelf.rewards =  [PDRewardStore allRewardsForBrandId:weakSelf.brand.identifier];
    weakSelf.rewardsLoading = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
      if (weakSelf.controller != nil) {
        [weakSelf.controller.tableView reloadData];
        [weakSelf.controller.tableView setUserInteractionEnabled:YES];
      }
    });
  } failure:^(NSError * _Nonnull error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      weakSelf.rewardsLoading = NO;
      if (weakSelf.controller != nil) {
        [weakSelf.controller.tableView reloadData];
        [weakSelf.controller.tableView setUserInteractionEnabled:YES];
      }
    });
  }];
}

- (void) fetchAllRewards {
  __weak typeof(self) weakSelf = self;
  [[PDAPIClient sharedInstance] getAllRewardsSuccess:^{
    weakSelf.rewards =  [PDRewardStore orderedByDistanceFromUser];
    weakSelf.rewardsLoading = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
      if (weakSelf.controller != nil) {
        [weakSelf.controller.tableView reloadData];
        [weakSelf.controller.tableView setUserInteractionEnabled:YES];
      }
    });
  } failure:^(NSError * _Nonnull error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      weakSelf.rewardsLoading = NO;
      if (weakSelf.controller != nil) {
        [weakSelf.controller.tableView setUserInteractionEnabled:YES];
      }
    });
  }];
}

- (void) fetchInbox {
  PDMessageAPIService *service = [[PDMessageAPIService alloc] init];
  __weak typeof(self) weakSelf = self;
  [service fetchMessagesCompletion:^(NSArray *messages, NSError *error){
    if (error) {
			PDLogError(@"Error while fetching messages. Error: %@", error.localizedDescription);
		}
    [[NSNotificationCenter defaultCenter] postNotificationName:ShouldUpdateTableView object:nil];
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
      [[NSNotificationCenter defaultCenter] postNotificationName:ShouldUpdateTableView object:nil];
		});
	} failure:^(NSError *error){
		PDLogError(@"Locations Fail: %@",error);
		dispatch_async(dispatch_get_main_queue(), ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:ShouldUpdateTableView object:nil];
		});
	}];
}

- (void) fetchWallet {
  if (_brand) {
    [self fetchWalletForBrand];
  } else {
    [self fetchAllWallet];
  }
}

- (void) fetchWalletForBrand {
	__weak typeof(self) weakSelf = self;
	[[PDAPIClient sharedInstance] getRewardsInWalletSuccess:^() {
		
		NSMutableArray *arr = [NSMutableArray array];
		for (id r in [PDWallet orderedByDateMulti]) {
//			if (r.brandId == _brand.identifier) {
				[arr addObject:r];
//			}
		}
    weakSelf.wallet = [arr copy];
    [[NSNotificationCenter defaultCenter] postNotificationName:ShouldUpdateTableView object:nil];
	} failure:^(NSError *error) {
		//TODO: Handle Error
		[[NSNotificationCenter defaultCenter] postNotificationName:ShouldUpdateTableView object:nil];
	}];
}


/*

- (void) fetchAllWallet {
    __weak typeof(self) weakSelf = self;
    [[PDAPIClient sharedInstance] getRewardsInWalletSuccess:^() {
        if (weakSelf.controller != nil) {
            weakSelf.wallet = [PDWallet orderedByDateMulti];
            [weakSelf.controller.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            [weakSelf.controller.tableView setUserInteractionEnabled:YES];
        }
    } failure:^(NSError *error) {
        //TODO: Handle Error
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.controller != nil) {
                [weakSelf.controller.tableView reloadData];
                [weakSelf.controller.tableView setUserInteractionEnabled:YES];
            }
        });
    }];
}

*/


 
- (void) fetchAllWallet {
	__weak typeof(self) weakSelf = self;
	[[PDAPIClient sharedInstance] getRewardsInWalletSuccess:^() {
    weakSelf.wallet = [PDWallet orderedByDateMulti];
    [[NSNotificationCenter defaultCenter] postNotificationName:ShouldUpdateTableView object:nil];
	} failure:^(NSError *error) {
		//TODO: Handle Error
		[[NSNotificationCenter defaultCenter] postNotificationName:ShouldUpdateTableView object:nil];
	}];
}











- (void) fetchFeed {
	_feedLoading = YES;
	__weak typeof(self) weakSelf = self;
	[[PDAPIClient sharedInstance] getFeedsSuccess:^{
    weakSelf.feed = [PDFeeds feed];
    [[NSNotificationCenter defaultCenter] postNotificationName:ShouldUpdateTableView object:nil];
    _feedLoading = NO;
	} failure:^(NSError *error){
		//TODO: Handle Error
		_feedLoading = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:ShouldUpdateTableView object:nil];
	}];
}

- (void) setupView {
  if ([_controller respondsToSelector:@selector(edgesForExtendedLayout)]) {
    _controller.edgesForExtendedLayout = UIRectEdgeNone;
  }
  
  //  if (_brand) {
  //    [_controller.tableView.tableHeaderView setFrame:CGRectMake(0, 0, _controller.tableView.frame.size.width, 190)];
  //  } else {
  [_controller.tableView.tableHeaderView setFrame:CGRectMake(0, 0, _controller.tableView.frame.size.width, 140)];
  //  }
  
  [_controller.tableView.tableHeaderView setBackgroundColor:PopdeemColor(PDThemeColorPrimaryApp)];
  
  if (!_tableHeaderImageView) {
    if (PopdeemThemeHasValueForKey(@"popdeem.images.homeHeaderImage") || _brand.coverImage != nil) {
      _tableHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _controller.tableView.frame.size.width, 140)];
      if (_brand.coverImage) {
        [_tableHeaderImageView setImage:_brand.coverImage];
      } else if (_brand && [_brand.coverUrlString rangeOfString:@"default"].location == NSNotFound){
        NSURL *url = [NSURL URLWithString:_brand.coverUrlString];
        NSURLSessionTask *task2 = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
              dispatch_async(dispatch_get_main_queue(), ^{
                [_tableHeaderImageView setImage:image];
                [_brand setCoverImage:image];
              });
            }
          }
        }];
        [task2 resume];
      }  else if (PopdeemThemeHasValueForKey(@"popdeem.images.homeHeaderImage")) {
        [_tableHeaderImageView setImage:PopdeemImage(@"popdeem.images.homeHeaderImage")];
      }
      [_tableHeaderImageView setContentMode:UIViewContentModeScaleAspectFill];
      [_tableHeaderImageView setClipsToBounds:YES];
      UIView *gradientView = [[UIView alloc] initWithFrame:_tableHeaderImageView.frame];
      [gradientView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
      [_controller.tableView.tableHeaderView addSubview:_tableHeaderImageView];
      [_controller.tableView.tableHeaderView addSubview:gradientView];
    }
  }
  
  if (!_tableHeaderLabel) {
    _tableHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 27.5, _controller.tableView.tableHeaderView.frame.size.width-40, 100)];
    [_tableHeaderLabel setTextAlignment:NSTextAlignmentCenter];
    [_tableHeaderLabel setNumberOfLines:3];
    [_tableHeaderLabel setFont:PopdeemFont(PDThemeFontBold, 14)];
    [_tableHeaderLabel setTextColor:PopdeemColor(PDThemeColorHomeHeaderText)];
    if (_brand) {
      [_tableHeaderLabel setText:[NSString stringWithFormat:@"Share your %@ experience on social networks to earn more rewards.", _brand.name]];
    } else {
      [_tableHeaderLabel setText:translationForKey(@"popdeem.home.header.titleText", @"Share your experience on social networks to earn more rewards.")];
    }
    [_tableHeaderLabel sizeToFit];
    [_tableHeaderLabel setFrame:CGRectMake((_controller.tableView.tableHeaderView.frame.size.width-_tableHeaderLabel.frame.size.width)/2, (_controller.tableView.tableHeaderView.frame.size.height-_tableHeaderLabel.frame.size.height)/2, _tableHeaderLabel.frame.size.width, _tableHeaderLabel.frame.size.height)];
    [_controller.tableView.tableHeaderView addSubview:_tableHeaderLabel];
  }
  
  if (_brand) {
    //    //Setup the brand View
    //    _brandView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, _controller.view.frame.size.width, 50)];
    //    [_controller.tableView.tableHeaderView addSubview:_brandView];
    //    [_brandView setBackgroundColor:[UIColor whiteColor]];
    //    [_controller.tableView.tableHeaderView addSubview:_brandView];
    //
    //    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2.5, 45, 45)];
    //    _logoImageView.layer.minificationFilter = kCAFilterTrilinear;
    //    _logoImageView.layer.shouldRasterize = YES;
    //    _logoImageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    //    if (_brand.logoImage) {
    //      [_logoImageView setImage:_brand.logoImage];
    //    } else {
    //      if ([_brand.logoUrlString rangeOfString:@"default"].location == NSNotFound) {
    //        NSURL *url = [NSURL URLWithString:_brand.logoUrlString];
    //        NSURLSessionTask *task2 = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //          if (data) {
    //            UIImage *image = [UIImage imageWithData:data];
    //            if (image) {
    //              dispatch_async(dispatch_get_main_queue(), ^{
    //                [_logoImageView setImage:image];
    //                [_brand setLogoImage:image];
    //              });
    //            }
    //          }
    //        }];
    //        [task2 resume];
    //        [_logoImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
    //      }
    //    }
    //    [_brandView addSubview:_logoImageView];
    //    [_logoImageView setBackgroundColor:[UIColor whiteColor]];
    //    [_logoImageView setContentMode:UIViewContentModeScaleAspectFill];
    //
    //    _brandNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, _brandView.frame.size.width-61-8, 30)];
    //    [_brandNameLabel setText:_brand.name];
    //    [_brandNameLabel setFont:PopdeemFont(PDThemeFontBold, 17)];
    //    [_brandNameLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
    //    [_brandView addSubview:_brandNameLabel];
    
    //Colours for Brand
    if (_brand.theme) {
      [_controller.tableView.tableHeaderView setBackgroundColor:PopdeemColorFromHex(_brand.theme.primaryAppColor)];
      [_tableHeaderLabel setTextColor:PopdeemColor(PDThemeColorHomeHeaderText)];
    }
  }
}

- (void) updateSubViews {
  //  if (_brand) {
  //    [_controller.tableView.tableHeaderView setFrame:CGRectMake(0, 0, _controller.tableView.frame.size.width, 190)];
  //    [_tableHeaderView setFrame:CGRectMake(0, 0, _controller.tableView.frame.size.width, 205)];
  //  } else {
  [_controller.tableView.tableHeaderView setFrame:CGRectMake(0, 0, _controller.tableView.frame.size.width, 140)];
  [_tableHeaderView setFrame:CGRectMake(0, 0, _controller.view.frame.size.width, 140)];
  //  }
  [_tableHeaderLabel setFrame:CGRectMake(20, 45, _controller.tableView.tableHeaderView.frame.size.width-40, 50)];
  if (_tableHeaderImageView) {
    [_tableHeaderImageView setFrame:_controller.tableView.tableHeaderView.frame];
  }
}

- (void) claimNoAction:(PDReward*)reward closestLocation:(PDLocation*)loc {
  __weak typeof(reward) weakReward = reward;
  __weak typeof(self) weakSelf = self;
  if (_controller.loadingView) {
    [_controller.loadingView hideAnimated:YES];
  }
  _controller.loadingView = [[PDUIModalLoadingView alloc]
                             initForView:self.controller.navigationController.view
                             titleText:@"Please Wait"
                             descriptionText:@"Claiming your Reward"];
  
  [_controller.loadingView showAnimated:YES];
  PDLocation *location = [[PDLocation alloc] init];
  location.latitude = 0.0;
  location.longitude = 0.0;
  [[PDAPIClient sharedInstance] claimReward:reward.identifier
                                   location:location
                                withMessage:nil
                              taggedFriends:nil
                                      image:nil
                                   facebook:NO
                                    twitter:NO
                                  instagram:NO
                                    success:^(){
                                      PDLog(@"No Action Reward Was Claimed");
                                      [PDRewardStore deleteReward:weakReward.identifier];
                                      weakSelf.rewards = [PDRewardStore orderedByDistanceFromUser];
                                      [weakSelf.controller.tableView reloadData];
                                      if (weakSelf.controller.loadingView) {
                                        [weakSelf.controller.loadingView hideAnimated:YES];
                                      }
                                      [weakSelf.controller moveToSection:2];
                                      [self fetchWallet];
                                    } failure:^(NSError *error) {
                                      PDLog(@"An error occurred when Claiming No Action Reward;");
                                      [weakSelf.controller.loadingView hideAnimated:YES];
                                      UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                                        message:@"Something went wrong when claiming your reward. Please try again later."
                                                                                       delegate:self.controller
                                                                              cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                                      [failure show];
                                    }];
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
