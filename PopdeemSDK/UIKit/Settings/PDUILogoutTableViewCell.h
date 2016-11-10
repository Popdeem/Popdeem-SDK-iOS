//
//  PDUILogoutTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 13/10/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUISettingsViewController.h"

@interface PDUILogoutTableViewCell : UITableViewCell
@property (nonatomic, assign) PDUISettingsViewController *parent;
@property (nonatomic, retain)  UIButton *logoutButton;

@end
