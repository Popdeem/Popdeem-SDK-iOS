//
//  PDUINoRewardTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDUINoRewardTableViewCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *infoLabel;
- (void) setupWithMessage:(NSString*)message;

@end
