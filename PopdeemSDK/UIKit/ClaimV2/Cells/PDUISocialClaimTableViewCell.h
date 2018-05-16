//
//  PDUISocialClaimTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/05/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDReward.h"

@class PDUIClaimV2ViewController;

@interface PDUISocialClaimTableViewCell : UITableViewCell

@property (nonatomic,assign) PDUIClaimV2ViewController *parent;
@property (nonatomic) PDSocialMediaType socialMediaType;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *socialImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *socialLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *socialSwitch;

- (void) setSocialNetwork:(PDSocialMediaType)mediaType;
- (void) startAnimatingSpinner;
- (void) stopAnimatingSpinner;
- (void) setEnabled:(BOOL)enabled;

@end
