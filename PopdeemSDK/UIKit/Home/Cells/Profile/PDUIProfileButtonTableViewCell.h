//
//  PDUIProfileButtonTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/01/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUICustomBadge.h"

@interface PDUIProfileButtonTableViewCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, retain) PDUICustomBadge *badge;
@property (nonatomic) BOOL shouldShowBadge;



@end
