	//
//  PDUIMessageLogoutCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/05/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIMessageLogoutCell.h"
#import "PDTheme.h"
#import "PopdeemSDK.h"

@implementation PDUIMessageLogoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype) initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		float centerline = frame.size.height/2;
		float buttonheight = frame.size.height-20;
		float buttonWidth = frame.size.width/3;
		float buttonX = (frame.size.width/2) - (buttonWidth/2);
		float buttonY = 10;
		
		_logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonheight)];
		[_logoutButton setBackgroundColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
		[_logoutButton setTitleColor:PopdeemColor(@"popdeem.colors.primaryInverseColor") forState:UIControlStateNormal];
		[_logoutButton.titleLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 14)];
		[_logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
		[_logoutButton addTarget:self action:@selector(logoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_logoutButton];
		return self;
	}
	return nil;
}

- (void) logoutButtonPressed:(id)sender {
	NSLog(@"Logging out");
	[PopdeemSDK logout];
}

@end
