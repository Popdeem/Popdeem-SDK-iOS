//
//  MessageCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 02/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *logoView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *bodyLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *timeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *indicatorView;


@end
