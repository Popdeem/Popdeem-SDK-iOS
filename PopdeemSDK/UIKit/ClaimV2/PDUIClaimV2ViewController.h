//
//  PDUIClaimV2ViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/05/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDReward.h"

@interface PDUIClaimV2ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *rewardImageView;

@property (nonatomic, assign) PDReward *reward;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *rewardView;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *continueButton;

- (instancetype) initFromNib;
- (instancetype) initWithReward:(PDReward*)reward;
- (void) setupWithReward:(PDReward*)reward;

@end
