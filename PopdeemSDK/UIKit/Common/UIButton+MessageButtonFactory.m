//
//  UIButton+MessageButtonFactory.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/12/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "UIButton+MessageButtonFactory.h"
#import "PDUtils.h"
#import "PDMessageStore.h"
#import "PDTheme.h"

@implementation UIButton (MessageButtonFactory)

+ (UIButton*) inboxButtonWithFrame:(CGRect)frame {
	UIButton *theButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[theButton setFrame:frame];
	theButton.backgroundColor = [UIColor clearColor];
	theButton.tintColor = PopdeemColor(PDThemeColorHomeHeaderText);
	[theButton setImage:PopdeemImage(@"pduikit_mail") forState:UIControlStateNormal];
	if ([PDMessageStore unreadCount] > 0) {
		NSUInteger unread = [PDMessageStore unreadCount];
		float width = theButton.frame.size.width;
		
		CGRect topRight = CGRectMake(width-9, -4, 12, 12);
		UILabel *lbl_card_count = [[UILabel alloc]initWithFrame:topRight];
		lbl_card_count.textColor = [UIColor whiteColor];
		lbl_card_count.textAlignment = NSTextAlignmentCenter;
    lbl_card_count.text = [NSString stringWithFormat:@"%ld",(unsigned long)unread];
		lbl_card_count.layer.borderWidth = 1;
		lbl_card_count.layer.cornerRadius = 6;
		lbl_card_count.layer.masksToBounds = YES;
		lbl_card_count.layer.borderColor =[[UIColor clearColor] CGColor];
		lbl_card_count.layer.shadowColor = [[UIColor clearColor] CGColor];
		lbl_card_count.layer.shadowOffset = CGSizeMake(0.0, 0.0);
		lbl_card_count.layer.shadowOpacity = 0.0;
		lbl_card_count.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:1.0];
		lbl_card_count.font = [UIFont systemFontOfSize:8];
		[theButton addSubview:lbl_card_count];
	}
	return theButton;
}

@end
