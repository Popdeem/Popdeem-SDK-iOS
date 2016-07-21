//
//  PDUIBrandTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDUIBrandTableViewCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *headerImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *logoImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *messageLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *disclosureIndicator;

@end
