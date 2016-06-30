//
//  PDUICardViewModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 17/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDUICardViewController.h"

@interface PDUICardViewModel : NSObject

@property (nonatomic, assign) PDUICardViewController *controller;
@property (nonatomic, retain) NSString *headerText;
@property (nonatomic, retain) NSString *bodyText;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *actionButtonTitle;
@property (nonatomic, retain) NSArray *otherButtonTitles;

@property (nonatomic, retain) UIColor *headerColor;
@property (nonatomic, retain) UIColor *headerLabelColor;
@property (nonatomic, retain) UIColor *bodyLabelColor;
@property (nonatomic, retain) UIColor *actionButtonColor;
@property (nonatomic, retain) UIColor *actionButtonLabelColor;
@property (nonatomic, retain) UIColor *otherButtonsColor;
@property (nonatomic, retain) UIColor *otherButtonsLabelColor;

@property (nonatomic, retain) UIFont *headerFont;
@property (nonatomic, retain) UIFont *bodyFont;
@property (nonatomic, retain) UIFont *actionButtonFont;
@property (nonatomic, retain) UIFont *otherButtonsFont;

- (instancetype) initWithController:(PDUICardViewController*)controller
												 headerText:(NSString*)headerText
													 bodyText:(NSString*)bodyText
													image:(UIImage*)image
									actionButtonTitle:(NSString*)actionButtonTitle
									otherButtonTitles:(NSArray*)otherButtonTitles;


@end
