//
//  PDUINoRewardTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBrandTheme.h"

@interface PDUINoRewardTableViewCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic, retain) PDBrandTheme *theme;

- (void) setupWithMessage:(NSString*)message;

@end
