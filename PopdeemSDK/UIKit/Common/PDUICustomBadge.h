//
//  PDUICustomBadge.h
//  Bolts-iOS10.0
//
//  Created by Niall Quinn on 28/02/2018.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PDTheme.h"
#import "PDUtils.h"

@interface PDUICustomBadge : UIView {
  
  NSString *badgeText;
  UIColor *badgeTextColor;
  UIColor *badgeInsetColor;
  UIColor *badgeFrameColor;
  BOOL badgeFrame;
  BOOL badgeShining;
  CGFloat badgeCornerRoundness;
  CGFloat badgeScaleFactor;
}

@property(nonatomic,retain) NSString *badgeText;
@property(nonatomic,retain) UIColor *badgeTextColor;
@property(nonatomic,retain) UIColor *badgeInsetColor;
@property(nonatomic,retain) UIColor *badgeFrameColor;

@property(nonatomic,readwrite) BOOL badgeFrame;
@property(nonatomic,readwrite) BOOL badgeShining;

@property(nonatomic,readwrite) CGFloat badgeCornerRoundness;
@property(nonatomic,readwrite) CGFloat badgeScaleFactor;

+ (PDUICustomBadge*) customBadgeWithString:(NSString *)badgeString;
+ (PDUICustomBadge*) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining;


@end
