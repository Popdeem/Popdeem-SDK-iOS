//
//  PDUIRewardV2TableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/01/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDUIRewardV2TableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *backingCard;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *rewardImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *label;

@end
