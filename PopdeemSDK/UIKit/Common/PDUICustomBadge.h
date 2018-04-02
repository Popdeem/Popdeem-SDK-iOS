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
#import "PDConstants.h"

@interface PDUICustomBadge : UIView {
  
}

@property(nonatomic,retain) NSString *badgeText;
@property(nonatomic,retain) UIColor *badgeTextColor;
@property(nonatomic,retain) UIColor *badgeInsetColor;
@property(nonatomic,retain) UIColor *badgeFrameColor;

@property(nonatomic) BOOL badgeFrame;
@property(nonatomic) BOOL badgeShining;

@property(nonatomic) CGFloat badgeCornerRoundness;
@property(nonatomic) CGFloat badgeScaleFactor;

+ (PDUICustomBadge*) customBadgeWithString:(NSString *)badgeString;
+ (PDUICustomBadge*) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale;
- (void) autoBadgeSizeWithString:(NSString *)badgeString;

@end
