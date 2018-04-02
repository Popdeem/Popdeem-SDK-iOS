//
//  PDUIBrandTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBrand.h"

@interface PDUIBrandTableViewCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *headerImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *logoImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *messageLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *disclosureIndicator;
@property (nonatomic, assign) PDBrand *brand;

- (void) setupForBrand:(PDBrand*)b;

@end
