//
//  PDSingleMessageViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 15/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMessage.h"

@interface PDUISingleMessageViewController : UIViewController

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *senderTagLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *senderLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *dateTagLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *dateLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleTagLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *bodyTaglabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *bodyLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *headerView;

- (instancetype) initFromNib;
- (void) setMessage:(PDMessage*)message;
- (void) renderView;
- (void) updateImage;

@end
