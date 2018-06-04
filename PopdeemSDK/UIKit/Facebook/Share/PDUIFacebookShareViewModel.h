//
//  PDUIFacebookShareViewModel.h
//  Bolts
//
//  Created by Niall Quinn on 22/05/2018.
//

#import <Foundation/Foundation.h>

@class PDUIFacebookShareViewController;

@interface PDUIFacebookShareViewModel : NSObject


@property (nonatomic, assign) PDUIFacebookShareViewController *controller;
@property (nonatomic, retain) NSString *viewOneLabelOneText;
@property (nonatomic, retain) NSString *viewOneLabelTwoText;
@property (nonatomic, retain) NSString *viewThreeLabelOneText;
@property (nonatomic, retain) NSString *viewTwoLabelOneText;
@property (nonatomic, retain) NSString *viewTwoLabelTwoText;
@property (nonatomic, retain) NSString *viewThreeLabelTwoText;
@property (nonatomic, retain) NSString *viewOneActionButtonText;
@property (nonatomic, retain) NSString *viewTwoActionButtonText;
@property (nonatomic, retain) NSString *viewThreeActionButtonText;


@property (nonatomic, retain) UIFont *viewOneLabelOneFont;
@property (nonatomic, retain) UIFont *viewOneLabelTwoFont;
@property (nonatomic, retain) UIFont *viewTwoLabelOneFont;
@property (nonatomic, retain) UIFont *viewTwoLabelTwoFont;
@property (nonatomic, retain) UIFont *viewThreeLabelOneFont;
@property (nonatomic, retain) UIFont *viewThreeLabelTwoFont;
@property (nonatomic, retain) UIFont *viewOneActionButtonFont;
@property (nonatomic, retain) UIFont *viewTwoActionButtonFont;
@property (nonatomic, retain) UIFont *viewThreeActionButtonFont;

@property (nonatomic, retain) UIColor *viewOneLabelOneColor;
@property (nonatomic, retain) UIColor *viewOneLabelTwoColor;
@property (nonatomic, retain) UIColor *viewTwoLabelOneColor;
@property (nonatomic, retain) UIColor *viewTwoLabelTwoColor;
@property (nonatomic, retain) UIColor *viewThreeLabelOneColor;
@property (nonatomic, retain) UIColor *viewThreeLabelTwoColor;
@property (nonatomic, retain) UIColor *viewOneActionButtonColor;
@property (nonatomic, retain) UIColor *viewOneActionButtonTextColor;
@property (nonatomic, retain) UIColor *viewOneActionButtonBorderColor;
@property (nonatomic, retain) UIColor *viewTwoActionButtonColor;
@property (nonatomic, retain) UIColor *viewTwoActionButtonTextColor;
@property (nonatomic, retain) UIColor *viewThreeActionButtonColor;
@property (nonatomic, retain) UIColor *viewThreeActionButtonTextColor;

@property (nonatomic, retain) UIImage *viewOneImage;
@property (nonatomic, retain) UIImage *viewTwoImage;
@property (nonatomic, retain) UIImage *viewThreeImage;

@property (nonatomic) BOOL facebookInstalled;

- (instancetype) initWithController:(PDUIFacebookShareViewController*)controller;
- (void) setup;

@end
