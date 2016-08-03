//
//  PDUIInstagramUnverifiedWalletTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDReward.h"
@protocol WakeableCell <NSObject>
- (void) wake;
@end

@interface PDUIInstagramUnverifiedWalletTableViewCell : UITableViewCell <WakeableCell> {
	BOOL verifying;
}

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *rewardImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mainLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (nonatomic, assign) PDReward *reward;

- (void) setupForReward:(PDReward*)reward;
- (void) wake;
- (void) beginVerifying;
@end

