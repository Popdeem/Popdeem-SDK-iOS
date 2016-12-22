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

@implementation PDUIInboxButton

- (instancetype) initWithFrame:(CGRect)frame {
	if (self = [[super alloc ]initWithFrame:frame]) {
		[self setup];
		return self;
	}
	return nil;
}

- (void) setup {
	self.buttonType = UIButtonTypeSystem;
	self.backgroundColor = [UIColor clearColor];
	self.tintColor = PopdeemColor(PDThemeColorPrimaryInverse);
	[self setImage:PopdeemImage(@"pduikit_mail") forState:UIControlStateNormal];
}

@end
