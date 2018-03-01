//
//  PDUITierEventTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 01/03/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDTierEvent.h"

@interface PDUITierEventTableViewCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mainLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *emojiLabel;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *infoLabel;

- (void) setupForTierEvent:(PDTierEvent*)event;

@end
