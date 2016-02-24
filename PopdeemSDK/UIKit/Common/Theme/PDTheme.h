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

#define PopdeemThemeHasValueForKey(key) \
[[PDTheme sharedInstance] hasValueForKey:(key)]

#define PopdeemFont(key,size) \
fontForKey(key,size)

#define CalcInterest(x,y) ( x * y )

#define PopdeemFontName(key)\
[[PDTheme sharedInstance] fontNameForKey:(key)]

@interface PDTheme : NSObject

+ (instancetype)sharedInstance;
+ (instancetype)setupWithFileName:(NSString*)fileName;

- (UIImage*)imageForKey:(NSString*)key;
- (UIColor*)colorForKey:(NSString*)key;
- (NSString*)fontNameForKey:(NSString*)key;
- (UIFont*) fontForKey:(NSString*)key size:(CGFloat)size;
- (BOOL) hasValueForKey:(NSString*)key;

extern UIFont *fontForKey(NSString *key, CGFloat size);

@end