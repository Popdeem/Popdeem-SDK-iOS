//
//  PDUIRewardV2TableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/01/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDReward.h"
#import "PDBrandTheme.h"

@interface PDUIRewardV2TableViewCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UIView *backingCard;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *infoArea;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *rewardImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *label;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *actionLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *expiryLabel;

+ (PDUIRewardV2TableViewCell *)cellFromNibNamed:(NSString *)nibName;
- (id) initWithFrame:(CGRect)frame;
- (void) setupForReward:(PDReward*)reward;
- (void) setupForReward:(PDReward *)reward theme:(PDBrandTheme*)theme;

@end
