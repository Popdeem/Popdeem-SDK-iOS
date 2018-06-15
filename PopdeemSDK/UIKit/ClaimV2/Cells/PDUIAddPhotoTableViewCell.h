//
//  PDUIAddPhotoTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/05/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDUIAddPhotoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *addedPhotoImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *changePhotoLabel;
- (void) setPhoto:(UIImage*)photo;
@end
