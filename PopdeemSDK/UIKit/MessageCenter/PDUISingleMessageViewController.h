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
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *topLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *bottomLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *headerView;

- (instancetype) initFromNib;
- (void) setMessage:(PDMessage*)message;
- (void) renderView;
- (void) updateImage;

@end
