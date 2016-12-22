//
//  PDHomeViewModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PDUIHomeViewController.h"
#import "PDLocation.h"
#import "PDReward.h"

@interface PDUIHomeViewModel : NSObject

@property (nonatomic, assign) PDBrand *brand;
@property (nonatomic, assign) PDUIHomeViewController *controller;
@property (nonatomic) PDLocation *closestLocation;

@property (nonatomic) NSString *headerTitleString;
@property (nonatomic) NSString *headerImageName;
@property (nonatomic) UIView *tableHeaderView;
@property (nonatomic) UIView *brandView;
@property (nonatomic) UILabel *brandNameLabel;
@property (nonatomic) UILabel *tableHeaderLabel;
@property (nonatomic) UIImageView *tableHeaderImageView;
@property (nonatomic) UIImageView *logoImageView;

//Colors
@property (nonatomic) UIColor *navColor;
@property (nonatomic) UIColor *navTextColor;
@property (nonatomic) UIColor *viewBackgroundColor;
@property (nonatomic) UIColor *tableViewBackgroundColor;
@property (nonatomic) UIColor *headerBackgroundColor;

//Data
@property (nonatomic, strong) NSArray *rewards;
@property (nonatomic, strong) NSArray *feed;
@property (nonatomic, strong) NSArray *wallet;
@property (nonatomic) BOOL feedLoading;
@property (nonatomic) BOOL rewardsLoading;
@property (nonatomic) BOOL walletLoading;

- (instancetype) initWithController:(PDUIHomeViewController*)controller;
- (void) setup;
- (void) fetchRewards;
- (void) fetchWallet;
- (void) fetchFeed;
- (void) setupView;
- (void) claimNoAction:(PDReward*)reward closestLocation:(PDLocation*)loc;
- (void) updateSubViews;
- (void) fetchMessages;
- (void) refreshMessageIcon;

@end
