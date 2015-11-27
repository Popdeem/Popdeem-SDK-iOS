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

@interface PDTheme : NSObject

+ (instancetype)sharedInstance;
+ (instancetype)setupWithFileName:(NSString*)fileName;

- (UIImage*)imageForKey:(NSString*)key;
- (UIColor*)colorForKey:(NSString*)key;

@end