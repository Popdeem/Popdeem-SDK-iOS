//
//  WalletTableViewCell.h
//  ios-test-v0.2
//
//  Created by Niall Quinn on 09/10/2014.
//  Copyright (c) 2014 Niall Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDReward.h"
#import "PDRewardHomeTableViewController.h"

@interface WalletTableViewCell : UITableViewCell

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UIView *tabView;
@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, retain) UILabel *rulesLabel;
@property (nonatomic, retain) UILabel *brandLabel;
@property (nonatomic, retain) UIView *redeemTag;
@property (nonatomic, retain) UILabel *redeemLabel;
@property (nonatomic, retain) UIImageView *logoImageView;
@property (nonatomic, retain) UIImageView *arrowImageView;
@property (nonatomic, retain) UILabel *expiresLabel;
@property (nonatomic, retain) PDReward *reward;

- (WalletTableViewCell*) initWithFrame:(CGRect)frame reward:(PDReward*)reward parent:(PDRewardHomeTableViewController*)parent;
- (void) rotateArrowRight;
- (void) rotateArrowDown;

@end
