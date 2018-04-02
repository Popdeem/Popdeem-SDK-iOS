//
//  UIColor+ColorOperations.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "UIColor+ColorOperations.h"

@implementation UIColor (ColorOperations)

- (UIColor *)lighterColor {
	CGFloat h, s, b, a;
	if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
	return [UIColor colorWithHue:h
										saturation:s
										brightness:MIN(b * 1.3, 1.0)
												 alpha:a];
	return nil;
}

- (UIColor *)darkerColor {
	CGFloat h, s, b, a;
	if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
	return [UIColor colorWithHue:h
										saturation:s
										brightness:b * 0.75
												 alpha:a];
	return nil;
}

@end
