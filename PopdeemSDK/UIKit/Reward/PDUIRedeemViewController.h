//
//  PDRedeemViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 01/03/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PDReward.h"

@interface PDUIRedeemViewController : UIViewController
@property (unsafe_unretained) IBOutlet UILabel *timerLabel;

@property (unsafe_unretained) IBOutlet UIView *cardView;
@property (nonatomic, strong) PDReward *reward;
@property (unsafe_unretained) IBOutlet UIImageView *logoImageView;
@property (unsafe_unretained) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained) IBOutlet UILabel *rulesLabel;
@property (unsafe_unretained) IBOutlet UILabel *topInfoLabel;
@property (unsafe_unretained) IBOutlet UILabel *bottomInfoLabel;
@property (unsafe_unretained) IBOutlet UILabel *brandLabel;
@property (unsafe_unretained) IBOutlet UIButton *doneButton;

- (instancetype) initFromNib;

@end
