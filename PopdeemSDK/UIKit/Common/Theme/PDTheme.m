//
// Created by John Doran on 25/11/2015.
// Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDTheme.h"

@interface PDTheme ()
@property(nonatomic, copy) NSDictionary *theme;
@end

static const NSString *kVariablesKey = @"Variables";


@implementation PDTheme

/**
 * Setup
 */
+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (instancetype)setupWithFileName:(NSString *)file {
    [[self sharedInstance] setTheme:[self loadThemeFromFile:file]];
    return [self sharedInstance];
}

+ (NSDictionary *)loadThemeFromFile:(NSString *)fileName {
    return [self jsonDictionaryFromData:[self readFileWithName:fileName extension:@"json"]];
}


- (UIImage *)imageForKey:(NSString *)key {
    UIImage *image = nil;
    id value = [self objectForKey:key];
    if (value){
        if ([value isKindOfClass:[NSString class]]){
            image = [UIImage imageNamed:value];
					if (!image) {
						image = [UIImage imageNamed:value inBundle:[self bundle] compatibleWithTraitCollection:nil];
					}
        }
    }
    return image;
}

- (id)objectForKey:(NSString *)key {
    if (self.theme == nil) {
        [NSException raise:@"Theme not setup" format:@""];
        return nil;
    }

    id value = [self.theme valueForKeyPath:key];

    if (value == nil) {
        [NSException raise:@"Value is not defined!" format:key];
    }

    return [self resolveVariable:value];
}

- (BOOL) hasValueForKey:(NSString *)key {
  if (self.theme == nil) {
    NSLog(@"Theme not setup");
    return NO;
  }
  id value = [self.theme valueForKeyPath:key];
  return value != nil;
}

+ (NSDictionary *)jsonDictionaryFromData:(NSData *)data {
    if (!data) {
        return nil;
    }

    NSError *error = nil;

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    if (error) {
        [NSException raise:@"JSON Error - can't parse" format:@""];
        return nil;
    }

    return json;
}

- (id)resolveVariable:(id)value {
    id resolvedValue = value;
    if ([value isKindOfClass:[NSString class]] && [value hasPrefix:@"$"]) {
        resolvedValue = [[self variables] valueForKeyPath:[value substringFromIndex:1]];
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableValue = [NSMutableArray array];
        for (id subValue in value) {
            [mutableValue addObject:[self resolveVariable:subValue]];
        }
        resolvedValue = mutableValue;
    }
    return resolvedValue;
}

- (NSDictionary *)variables {
    return self.theme[kVariablesKey];
}

+ (NSData *)readFileWithName:(NSString *)fileName extension:(NSString *)ext {
    NSError *error = nil;

    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
    if (!filePath) {
			filePath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:ext];
			if (!filePath) {
				filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"default_theme" ofType:@"json"];
				if (!filePath) {
					[NSException raise:@"Error loading theme" format:@""];
				}
				NSLog(@"You did not specify a theme file, or it was not found. Using default theme file");
			}
    }

    NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
    if (error) {
        [NSException raise:error.debugDescription format:@""];
    }
    return data;
}

/**
 * Colors
 */
- (UIColor *)findColorFromValue:(id)value {
    UIColor *color = nil;
    if ([value isKindOfClass:[NSString class]]) {
        color = [self colorFromHexString:value];
        if (!color) color = [self colorFromPatternImageString:value];
    } else if ([value isKindOfClass:[NSArray class]] && [value count] == 2) {
        color = [self findColorFromValue:value[0]];
        if (color) color = [color colorWithAlphaComponent:[(NSString *) value[1] floatValue]];
    }
    return color;
}


- (UIColor *)colorForKey:(NSString *)key {
    UIColor *color = nil;
    id value = [self objectForKey:key];
    if (value) {
        color = [self findColorFromValue:value];
    }
    return color;
}

- (UIColor *)colorFromPatternImageString:(NSString *)patternImageString {
    UIImage *patternImage = [UIImage imageNamed:patternImageString];
    if (patternImage) {
        return [UIColor colorWithPatternImage:patternImage];
    }
    return nil;
}


- (UIColor *)colorFromHexString:(NSString *)colorString {

    if ([colorString hasPrefix:@"#"]) {
        NSScanner *scanner = [NSScanner scannerWithString:[colorString substringFromIndex:1]];
        unsigned long long hexValue;
        if ([scanner scanHexLongLong:&hexValue]) {
            CGFloat red = ((hexValue & 0xFF0000) >> 16) / 255.0f;
            CGFloat green = ((hexValue & 0x00FF00) >> 8) / 255.0f;
            CGFloat blue = (hexValue & 0x0000FF) / 255.0f;
            return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        }
    }
    return nil;
}

- (NSString *)fontNameForKey:(NSString *)key {
  id value = [self objectForKey:key];
  if (value) {
    if ([value isKindOfClass:[NSString class]]){
      return value;
    }
  } else {
    NSString *globalFont = [self objectForKey:@"popdeem.global.fontName"];
    if ([globalFont isKindOfClass:[NSString class]]) {
      NSLog(@"PDTheme: No font specified for path: %@, returning global font",key);
      return globalFont;
    } else {
      [NSException raise:@"Font name not found and no global font name defined" format:@""];
    }
  }
  return nil;
}

UIFont* fontForKey(NSString *key, CGFloat size) {
  if ([[PDTheme sharedInstance] hasValueForKey:key]) {
    id value = [[PDTheme sharedInstance] objectForKey:key];
    if ([value isKindOfClass:[NSString class]]){
      UIFont *font = [UIFont fontWithName:value size:size];
      if (font) {
        return font;
      } else {
        NSLog(@"Font with name: %@ does not exist. Returning system font",value);
      }
    }
  } else {
    NSLog(@"No font defined for key: %@, returning system font",key);
  }
  return [UIFont systemFontOfSize:size];
}

- (NSBundle*) bundle {
	return [NSBundle bundleForClass:self.class];
}

- (NSString*) bundleName {
	return [[[NSBundle bundleForClass:self.class] bundleURL] lastPathComponent];
}

- (NSString*) imagePathForValue:(NSString*)value {
	NSString *imagePath = [[self bundle] pathForResource:value ofType:@"png"];
	if (imagePath) {
		return imagePath;
	}
	imagePath = [[self bundle] pathForResource:value ofType:@"jpg"];
	if (imagePath) {
		return imagePath;
	}
	return nil;
}

//- (UIFont*) fontForKey:(NSString*)key size:(CGFloat)size {
//  if ([self hasValueForKey:key]) {
//    id value = [self objectForKey:key];
//    if ([value isKindOfClass:[NSString class]]){
//      UIFont *font = [UIFont fontWithName:value size:size];
//      if (font) {
//        return font;
//      } else {
//        NSLog(@"Font with name: %@ does not exist. Returning system font",value);
//      }
//    }
//  } else {
//    NSLog(@"No font defined for key: %@, returning system font",key);
//  }
//  return [UIFont systemFontOfSize:size];
//}

@end