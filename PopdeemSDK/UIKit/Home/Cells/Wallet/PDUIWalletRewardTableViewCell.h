//
//  PDUIWalletRewardTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDReward.h"
#import "PDBrandTheme.h"

@interface PDUIWalletRewardTableViewCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *rewardImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mainLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (nonatomic, retain) PDBrandTheme *brandTheme;

- (void) setupForReward:(PDReward *)reward theme:(PDBrandTheme*)theme;
- (void) setupForReward:(PDReward*)reward;
- (void) rotateArrowDown;
- (void) rotateArrowRight;

@end
