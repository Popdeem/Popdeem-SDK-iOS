//
//  ProfileTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/01/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUIGratitudeProgressView.h"

@interface ProfileTableViewCell : UITableViewCell

@property (unsafe_unretained) IBOutlet UILabel *label;
@property (unsafe_unretained) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) PDUIGratitudeProgressView *progressView;

- (void) setProfile;
@end
