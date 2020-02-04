//
//  PDUISettingsViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramLoginDelegate.h"

@interface PDUISettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, InstagramLoginDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *tableHeaderImageView;
@property (nonatomic, retain) UILabel *tableHeaderNameLabel;

- (instancetype) initFromNib;
- (void) connectFacebookAccount;
- (void) disconnectFacebookAccount;
- (void) connectTwitterAccount;
- (void) disconnectTwitterAccount;
- (void) connectInstagramAccount;
- (void) disconnectInstagramAccount;
- (void) connectInstagramAccount:(NSString*)identifier accessToken:(NSString*)accessToken;
- (void) logoutUser;
- (NSInteger) numberOfSocialNetworksTurnedOn;

@end
