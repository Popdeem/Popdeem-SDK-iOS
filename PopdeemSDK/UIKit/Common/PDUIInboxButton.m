//
//  InboxButton.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/12/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIInboxButton.h"
#import "PDTheme.h"
#import "PDConstants.h"
#import "PDMessageStore.h"

@implementation PDUIInboxButton

- (instancetype) initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setup];
		return self;
	}
	return nil;
}

- (void) setup {
	self.backgroundColor = [UIColor clearColor];
	self.tintColor = PopdeemColor(PDThemeColorPrimaryInverse);
	[self setImage:PopdeemImage(@"pduikit_mail") forState:UIControlStateNormal];
	if ([PDMessageStore unreadCount] > 0) {
		NSUInteger unread = [PDMessageStore unreadCount];
		float width = self.frame.size.width;
//		float height = self.frame.size.height;
		
		CGRect topRight = CGRectMake(width-9, -4, 13, 13);
		UILabel *lbl_card_count = [[UILabel alloc]initWithFrame:topRight];
		lbl_card_count.textColor = [UIColor whiteColor];
		lbl_card_count.textAlignment = NSTextAlignmentCenter;
		lbl_card_count.text = [NSString stringWithFormat:@"%ld",unread];
		lbl_card_count.layer.borderWidth = 1;
		lbl_card_count.layer.cornerRadius = 8;
		lbl_card_count.layer.masksToBounds = YES;
		lbl_card_count.layer.borderColor =[[UIColor clearColor] CGColor];
		lbl_card_count.layer.shadowColor = [[UIColor clearColor] CGColor];
		lbl_card_count.layer.shadowOffset = CGSizeMake(0.0, 0.0);
		lbl_card_count.layer.shadowOpacity = 0.0;
		lbl_card_count.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:45.0/255.0 blue:143.0/255.0 alpha:1.0];
		lbl_card_count.font = [UIFont fontWithName:@"ArialMT" size:9];
		[self addSubview:lbl_card_count];
	}
}

@end
