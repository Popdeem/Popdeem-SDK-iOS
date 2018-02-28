//
//  PDUICustomBadge.m
//  Bolts-iOS10.0
//
//  Created by Niall Quinn on 28/02/2018.
//

#import "PDUICustomBadge.h"

@implementation PDUICustomBadge


- (id) initWithString:(NSString *)badgeString withScale:(CGFloat)scale
{
  self = [super initWithFrame:CGRectMake(0, 0, 25, 25)];
  if(self!=nil) {
    self.contentScaleFactor = [[UIScreen mainScreen] scale];
    self.backgroundColor = [UIColor clearColor];
    self.badgeText = badgeString;
    self.badgeTextColor = [UIColor whiteColor];
    self.badgeFrame = YES;
    self.badgeFrameColor = [UIColor whiteColor];
    self.badgeInsetColor = [UIColor redColor];
    self.badgeCornerRoundness = 0.4;
    self.badgeScaleFactor = scale;
    [self autoBadgeSizeWithString:badgeString];
  }
  return self;
}

- (id) initWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale
{
  self = [super initWithFrame:CGRectMake(0, 0, 25, 25)];
  if(self!=nil) {
    self.contentScaleFactor = [[UIScreen mainScreen] scale];
    self.backgroundColor = [UIColor clearColor];
    self.badgeText = badgeString;
    self.badgeTextColor = stringColor;
    self.badgeFrame = badgeFrameYesNo;
    self.badgeFrameColor = frameColor;
    self.badgeInsetColor = insetColor;
    self.badgeCornerRoundness = 0.40;
    self.badgeScaleFactor = scale;
    [self autoBadgeSizeWithString:badgeString];
  }
  return self;
}

// Use this method if you want to change the badge text after the first rendering
- (void) autoBadgeSizeWithString:(NSString *)badgeString
{
  CGSize retValue;
  CGFloat rectWidth, rectHeight;
  CGSize stringSize = [badgeString sizeWithAttributes:@{NSFontAttributeName : PopdeemFont(PDThemeFontBold, 12.0f)}];
  CGFloat flexSpace;
  if ([badgeString length]>=2) {
    flexSpace = [badgeString length];
    rectWidth = 15 + (stringSize.width + flexSpace); rectHeight = 25;
    retValue = CGSizeMake(rectWidth*badgeScaleFactor, rectHeight*badgeScaleFactor);
  } else {
    retValue = CGSizeMake(25*badgeScaleFactor, 25*badgeScaleFactor);
  }
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, retValue.width, retValue.height);
  self.badgeText = badgeString;
  [self setNeedsDisplay];
}

// Creates a Badge with a given Text
+ (PDUICustomBadge*) customBadgeWithString:(NSString *)badgeString
{
  return [[PDUICustomBadge alloc] initWithString:badgeString withScale:1.0];
}

+ (PDUICustomBadge*) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale
{
  return [[PDUICustomBadge alloc] initWithString:badgeString withStringColor:stringColor withInsetColor:insetColor withBadgeFrame:badgeFrameYesNo withBadgeFrameColor:frameColor withScale:scale];
}

// Draws the Badge with Quartz
-(void) drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect
{
  CGContextSaveGState(context);
  
  CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
  CGFloat puffer = CGRectGetMaxY(rect)*0.10;
  CGFloat maxX = CGRectGetMaxX(rect) - puffer;
  CGFloat maxY = CGRectGetMaxY(rect) - puffer;
  CGFloat minX = CGRectGetMinX(rect) + puffer;
  CGFloat minY = CGRectGetMinY(rect) + puffer;
  
  CGContextBeginPath(context);
  CGContextSetFillColorWithColor(context, [self.badgeInsetColor CGColor]);
  CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
  CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
  CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
  CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
  CGContextSetShadowWithColor(context, CGSizeMake(1.0,1.0), 3, [[UIColor blackColor] CGColor]);
  CGContextFillPath(context);
  
  CGContextRestoreGState(context);
  
}

-(void) drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect
{
  CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
  CGFloat puffer = CGRectGetMaxY(rect)*0.10;
  
  CGFloat maxX = CGRectGetMaxX(rect) - puffer;
  CGFloat maxY = CGRectGetMaxY(rect) - puffer;
  CGFloat minX = CGRectGetMinX(rect) + puffer;
  CGFloat minY = CGRectGetMinY(rect) + puffer;
  
  
  CGContextBeginPath(context);
  CGFloat lineSize = 2;
  if(self.badgeScaleFactor>1) {
    lineSize += self.badgeScaleFactor*0.25;
  }
  CGContextSetLineWidth(context, lineSize);
  CGContextSetStrokeColorWithColor(context, [self.badgeFrameColor CGColor]);
  CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
  CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
  CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
  CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
  CGContextClosePath(context);
  CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect {
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  [self drawRoundedRectWithContext:context withRect:rect];
  
  if (self.badgeFrame)  {
    [self drawFrameWithContext:context withRect:rect];
  }
  
  if ([self.badgeText length]>0) {
    [badgeTextColor set];
    CGFloat sizeOfFont = 13.5*badgeScaleFactor;
    if ([self.badgeText length]<2) {
      sizeOfFont += sizeOfFont*0.20;
    }
    UIFont *textFont = [UIFont boldSystemFontOfSize:sizeOfFont];
    CGSize textSize = [self.badgeText sizeWithFont:textFont];
    [self.badgeText drawAtPoint:CGPointMake((rect.size.width/2-textSize.width/2), (rect.size.height/2-textSize.height/2)) withFont:textFont];
  }
  
}

- (void)dealloc {
  [super dealloc];
}

@end
