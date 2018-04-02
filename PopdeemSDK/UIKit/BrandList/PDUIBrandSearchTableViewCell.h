//
//  PDUIBrandSearchTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBrand.h"

@interface PDUIBrandSearchTableViewCell : UITableViewCell
@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) UIImageView *logoImageView;
@property (nonatomic, retain) UIImageView *arrowImageView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *infoLabel;
@property (nonatomic, retain) UILabel *distanceLabel;
@property (nonatomic, assign) PDBrand *brand;

- (id) initWithFrame:(CGRect)frame brand:(PDBrand*)b;

@end
