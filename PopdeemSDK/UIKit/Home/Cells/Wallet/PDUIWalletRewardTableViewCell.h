//
//  PDUIWalletRewardTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDReward.h"

@interface PDUIWalletRewardTableViewCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *rewardImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mainLabel;

- (void) setupForReward:(PDReward*)reward;

@end
