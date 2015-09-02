//
//  PDBrand.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PDOpeningHoursWeek.h"

@interface PDBrand : NSObject

@property (nonatomic) NSInteger identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *logoUrlString;
@property (nonatomic, strong) NSString *coverUrlString;

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *web;
@property (nonatomic, strong) NSString *facebook;
@property (nonatomic, strong) NSString *twitter;

@property (nonatomic) NSInteger numberOfLocations;

@property (nonatomic) float distanceFromUser;

@property (nonatomic, strong) PDOpeningHoursWeek *openingHours;

@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) UIImage *logoImage;

- (id) initFromApi:(NSDictionary*)params;
- (NSComparisonResult)compareDistance:(PDBrand *)otherObject;

- (void) downloadCoverImageCompletion:(void (^)(BOOL success))completion;

- (void) downloadLogoImageCompletion:(void (^)(BOOL success))completion;

- (BOOL) isOpenNow;

@end
