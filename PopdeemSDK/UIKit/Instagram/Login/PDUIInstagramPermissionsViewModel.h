//
//  PDUIInstagramPermissionsViewModel.h
//  Pods
//
//  Created by Popdeem on 24/01/2020.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PDUIInstagramPermissionsViewController;

@interface PDUIInstagramPermissionsViewModel : NSObject

@property (nonatomic, assign) PDUIInstagramPermissionsViewController *controller;

@property (nonatomic, retain) NSString *viewOneLabelOneText;
@property (nonatomic, retain) UIFont *viewOneLabelOneFont;
@property (nonatomic, retain) UIColor *viewOneLabelOneColor;

@property (nonatomic, retain) NSString *viewOneLabelTwoText;
@property (nonatomic, retain) UIFont *viewOneLabelTwoFont;
@property (nonatomic, retain) UIColor *viewOneLabelTwoColor;

@property (nonatomic, retain) NSString *viewOneActionButtonText;
@property (nonatomic, retain) UIFont *viewOneActionButtonFont;
@property (nonatomic, retain) UIColor *viewOneActionButtonColor;
@property (nonatomic, retain) UIColor *viewOneActionButtonTextColor;
@property (nonatomic, retain) UIColor *viewOneActionButtonBorderColor;

@property (nonatomic, retain) UIImage *viewOneImage;

- (instancetype) initWithController:(PDUIInstagramPermissionsViewController*)controller;
- (void) setup;

@end
