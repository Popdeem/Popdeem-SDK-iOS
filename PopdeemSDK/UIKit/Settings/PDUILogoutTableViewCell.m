//
//  PDUILogoutTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 13/10/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUILogoutTableViewCell.h"

@implementation PDUILogoutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype) initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		_logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, self.frame.size.width-16, self.frame.size.height-16)];
		[self addSubview:_logoutButton];
		[_logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
		[_logoutButton addTarget:self action:@selector(logoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		return self;
	}
	return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)logoutButtonPressed:(id)sender {
	[_parent logoutUser];
}


@end
