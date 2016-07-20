//
//  PDUIRewardWithRulesTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 15/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDReward.h"

@interface PDUIRewardWithRulesTableViewCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *rewardImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *label;

- (NSString*) infoStringForReward:(PDReward*)reward;
- (void) setupForReward:(PDReward*)reward;

@end
