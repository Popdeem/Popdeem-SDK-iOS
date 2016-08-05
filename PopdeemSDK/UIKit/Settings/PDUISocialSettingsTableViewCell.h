//
//  PDUISocialSettingsTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUser.h"
#import "PDUISettingsViewController.h"

@interface PDUISocialSettingsTableViewCell : UITableViewCell
@property (nonatomic,assign) PDUISettingsViewController *parent;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *socialImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *socialLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *socialSwitch;

- (void) setSocialNetwork:(PDSocialMediaType)mediaType;
- (void) startAnimatingSpinner;
- (void) stopAnimatingSpinner;
@end
