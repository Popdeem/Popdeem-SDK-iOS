//
//  PDMultiLoginViewModelV2.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/01/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PDMultiLoginViewControllerV2.h"

@interface PDMultiLoginViewModelV2 : NSObject

@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIColor *titleColor;

@property (nonatomic, retain) NSString *bodyString;
@property (nonatomic, retain) UIFont *bodyFont;
@property (nonatomic, retain) UIColor *bodyColor;

@property (nonatomic, retain) UIColor *twitterButtonColor;
@property (nonatomic, retain) UIColor *twitterButtonTextColor;
@property (nonatomic, retain) UIFont *twitterButtonFont;
@property (nonatomic, retain) NSString *twitterButtonText;

@property (nonatomic, retain) UIColor *instagramButtonColor;
@property (nonatomic, retain) UIColor *instagramButtonTextColor;
@property (nonatomic, retain) UIFont *instagramButtonFont;
@property (nonatomic, retain) NSString *instagramButtonText;

@property (nonatomic, retain) UIColor *facebookButtonColor;
@property (nonatomic, retain) UIFont *facebookButtonFont;
@property (nonatomic, retain) NSString *facebookButtonText;

@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) PDReward *reward;

- (instancetype) initForViewController:(PDMultiLoginViewControllerV2*)controller reward:(PDReward*)reward;
- (void) setup;

@end
