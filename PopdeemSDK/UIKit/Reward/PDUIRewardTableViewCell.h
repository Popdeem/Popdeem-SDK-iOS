//
//  RewardTableViewCell.h
//  Popdeem
//
//  Created by Niall Quinn on 08/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDReward.h"

@interface PDUIRewardTableViewCell : UITableViewCell

@property (nonatomic, assign) PDReward *reward;
@property (nonatomic, retain) UIImageView *logoImageView;
@property (nonatomic, retain) UILabel *mainLabel;
@property (nonatomic, retain) UILabel *rulesLabel;
@property (nonatomic, retain) UILabel *infoLabel;

- (id) initWithFrame:(CGRect)frame reward:(PDReward*)reward;

@end
