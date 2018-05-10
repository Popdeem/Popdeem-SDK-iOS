//
//  PDUIClaimRewardTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/05/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDReward.h"

@interface PDUIClaimRewardTableViewCell : UITableViewCell

@property (nonatomic, assign) PDReward *reward;

- (void) setup;

@end
