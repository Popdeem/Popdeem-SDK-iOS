//
//  UIColor+ColorOperations.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "UIColor+ColorOperations.h"

@implementation UIColor (ColorOperations)

- (UIColor *)lighterColor{
	CGFloat r, g, b, a;
	if ([c getRed:&r green:&g blue:&b alpha:&a])
	return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
												 green:MIN(g + 0.2, 1.0)
													blue:MIN(b + 0.2, 1.0)
												 alpha:a];
	return nil;
}

- (UIColor *)darkerColor {
	CGFloat r, g, b, a;
	if ([c getRed:&r green:&g blue:&b alpha:&a])
	return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
												 green:MAX(g - 0.2, 0.0)
													blue:MAX(b - 0.2, 0.0)
												 alpha:a];
	return nil;
}

@end
