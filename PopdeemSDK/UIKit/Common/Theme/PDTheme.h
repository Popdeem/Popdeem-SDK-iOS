//
// Created by John Doran on 25/11/2015.
// Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PopdeemImage(key) \
[[PDTheme sharedInstance] imageForKey:(key)]

#define PopdeemColor(key) \
[[PDTheme sharedInstance] colorForKey:(key)]

#define PopdeemFontSize(key) \
[[PDTheme sharedInstance] fontSizeForKey:(key)]

#define PopdeemColorFromHex(key) \
[[PDTheme sharedInstance] findColorFromValue:(key)]

#define PopdeemThemeHasValueForKey(key) \
[[PDTheme sharedInstance] hasValueForKey:(key)]

#define PopdeemFont(key,size) \
fontForKey(key,size)

#define CalcInterest(x,y) ( x * y )

#define PopdeemFontName(key)\
[[PDTheme sharedInstance] fontNameForKey:(key)]

#define PopdeemSocialLoginVariation(key) \
[[PDTheme sharedInstance] socialLoginVariationForKey:(key)]

#define PopdeemSocialLoginTransition(key) \
[[PDTheme sharedInstance] socialLoginTransitionForKey:(key)]

@interface PDTheme : NSObject

+ (instancetype)sharedInstance;
+ (instancetype)setupWithFileName:(NSString*)fileName;

- (UIImage*)imageForKey:(NSString*)key;
- (UIColor*)colorForKey:(NSString*)key;
- (NSString*)fontSizeForKey:(NSString*)key;
- (NSString*)fontNameForKey:(NSString*)key;
- (BOOL) hasValueForKey:(NSString*)key;
- (UIColor *)findColorFromValue:(id)value;
- (NSString*)socialLoginVariationForKey:(NSString*)key;
- (NSString*)socialLoginTransitionForKey:(NSString*)key;

extern UIFont *fontForKey(NSString *key, CGFloat size);

@end
