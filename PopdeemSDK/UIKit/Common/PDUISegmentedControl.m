//
//  PDSegmentedControl.m
//  Popdeem
//
//  Created by Niall Quinn on 10/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDUISegmentedControl.h"
#import "PDTheme.h"
#import "PDConstants.h"
#import "PDMessageStore.h"

@implementation PDUISegmentedControl

- (instancetype) initWithItems:(NSArray *)items {
  if (self = [super initWithItems:items]) {
    [self setTintColor:[UIColor grayColor]];
    [self setBackgroundColor:PopdeemColor(PDThemeColorSegmentedControlBackground)];
    
    //Remove Background Selection
    [self setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
		UIImage *selectedImage = [self selectedImage:PopdeemColor(PDThemeColorSecondaryApp)];
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected
                                             barMetrics:UIBarMetricsDefault];
    
    [self setTitleTextAttributes:@{NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 14), NSForegroundColorAttributeName : PopdeemColor(PDThemeColorSegmentedControlForeground)} forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 14), NSForegroundColorAttributeName : PopdeemColor(PDThemeColorSegmentedControlForeground)} forState:UIControlStateSelected];
    
    //Remove Divider Image
    [self setDividerImage:[UIImage new] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:(UIBarMetricsDefault)];
    [self setDividerImage:[UIImage new] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:(UIBarMetricsDefault)];
    [self setDividerImage:[UIImage new] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:(UIBarMetricsDefault)];
    
    //Set Text Attributes
    
    [self setSelectedSegmentIndex:0];
    
    NSUInteger unread = 2;
    
    return self;
  }
  return nil;
}

- (void) applyTheme:(PDBrandTheme*)theme {
	UIImage *selectedImage = [self selectedImage:PopdeemColorFromHex(theme.primaryInverseColor)];
	[self setBackgroundImage:selectedImage forState:UIControlStateSelected
								barMetrics:UIBarMetricsDefault];

	[self setBackgroundColor:PopdeemColorFromHex(theme.primaryAppColor)];
	[self setTitleTextAttributes:@{NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 14), NSForegroundColorAttributeName : PopdeemColor(PDThemeColorSegmentedControlForeground)} forState:UIControlStateNormal];
	[self setTitleTextAttributes:@{NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 14), NSForegroundColorAttributeName : PopdeemColor(PDThemeColorSegmentedControlForeground)} forState:UIControlStateSelected];
}

//640*80 - 6

- (UIImage*) selectedImage:(UIColor*)color {
  UIImage *selectedImage = [self imageFromColor:color rect:CGRectMake(0, 0, 2, 6)];
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

- (void) didMoveToSuperview {

    float center = self.frame.size.height/2;

    NSString *segment3Text = [self titleForSegmentAtIndex:2];
    UILabel *dummyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [dummyLabel setText:segment3Text];
    [dummyLabel setFont:PopdeemFont(PDThemeFontPrimary, 14)];
    [dummyLabel sizeToFit];

    float segment3Width = self.frame.size.width/3;
    float segment3Center = self.frame.size.width - (segment3Width/2);
    float segment3TitleEnd = segment3Center + (dummyLabel.frame.size.width/2);
  
  if ([PDMessageStore unreadCount] > 0) {
    if (!_badge) {
      _badge = [PDUICustomBadge customBadgeWithString:[NSString stringWithFormat:@"%ld",(unsigned long)[PDMessageStore unreadCount]]
                                      withStringColor:[UIColor whiteColor]
                                       withInsetColor:[UIColor colorWithRed:0.98 green:0.05 blue:0.11 alpha:1.00]
                                       withBadgeFrame:YES
                                  withBadgeFrameColor:[UIColor whiteColor]
                                            withScale:0.70];
      [_badge setFrame:CGRectMake(segment3TitleEnd + 5, center-8.5, _badge.frame.size.width, _badge.frame.size.height)];
      [self addSubview:_badge];
    } else {
      [_badge autoBadgeSizeWithString:[NSString stringWithFormat:@"%ld",(unsigned long)[PDMessageStore unreadCount]]];
      [_badge setFrame:CGRectMake(segment3TitleEnd + 5, center-8.5, _badge.frame.size.width, _badge.frame.size.height)];
    }
  } else {
    if (_badge) {
      [_badge setHidden:YES];
    }
  }
}

@end
