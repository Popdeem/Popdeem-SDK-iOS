//
//  PDSegmentedControl.m
//  Popdeem
//
//  Created by Niall Quinn on 10/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDUISegmentedControl.h"
#import "PDTheme.h"

@implementation PDUISegmentedControl

- (instancetype) initWithItems:(NSArray *)items {
  if (self = [super initWithItems:items]) {
    [self setTintColor:[UIColor grayColor]];
    [self setBackgroundColor:PopdeemColor(@"popdeem.colors.segmentedControlBackgroundColor")];
    
    //Remove Background Selection
    [self setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *selectedImage = [self selectedImage];
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected
                                             barMetrics:UIBarMetricsDefault];
    
    [self setTitleTextAttributes:@{NSFontAttributeName : PopdeemFont(@"popdeem.fonts.primaryFont", 14), NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryFontColor")} forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{NSFontAttributeName : PopdeemFont(@"popdeem.fonts.primaryFont", 14), NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryFontColor")} forState:UIControlStateSelected];
    
    //Remove Divider Image
    [self setDividerImage:[UIImage new] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:(UIBarMetricsDefault)];
    [self setDividerImage:[UIImage new] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:(UIBarMetricsDefault)];
    [self setDividerImage:[UIImage new] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:(UIBarMetricsDefault)];
    
    //Set Text Attributes
    
    [self setSelectedSegmentIndex:0];
    
    return self;
  }
  return nil;
}

//640*80 - 6

- (UIImage*) selectedImage {
  UIImage *selectedImage = [self imageFromColor:PopdeemColor(@"popdeem.colors.primaryAppColor") rect:CGRectMake(0, 0, 2, 6)];
  UIImage *fullImage = [self imageFromColor:[UIColor clearColor] rect:CGRectMake(0, 0, 2, 80)];
  CGSize newSize = CGSizeMake(2, 80);
  UIGraphicsBeginImageContext(newSize);
  
  // Use existing opacity as is
  [fullImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
  [selectedImage drawInRect:CGRectMake(0, 74, 2, 6)];
  
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  return newImage;
}

- (UIImage *)imageFromColor:(UIColor *)color rect:(CGRect)rect {
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

@end
