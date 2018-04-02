//
//  MessageCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 02/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMessage.h"

@interface PDUIMessageCell : UITableViewCell

@property (nonatomic) UIImageView *logoView;
@property (nonatomic) UILabel *bodyLabel;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UIView *indicatorView;

- (void) configureForMessage:(PDMessage*)message;
- (instancetype) initWithFrame:(CGRect)frame message:(PDMessage*)message;

@end
